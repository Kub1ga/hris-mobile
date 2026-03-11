import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image/image.dart' as img;
import 'package:workmate_mobile/utils/facenet_service.dart';
import 'package:workmate_mobile/utils/secure_storage.dart';

class SelfieClockInPage extends StatefulWidget {
  const SelfieClockInPage({super.key});

  @override
  State<SelfieClockInPage> createState() => _SelfieClockInPageState();
}

class _SelfieClockInPageState extends State<SelfieClockInPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late final List<CameraDescription> _cameras;
  bool _isDetecting = false;
  late FaceMeshDetector _faceMeshDetector;
  List<FaceMesh> _faces = [];
  Size? _imageSize;
  InputImageRotation _rotation = InputImageRotation.rotation0deg;
  bool _isCapturing = false;
  FaceNetService faceNetService = FaceNetService();
  Size? _screenSize;
  SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  Timer? _captureTimer;
  CameraImage? _latestImage;
  FaceMesh? _latestFace;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _faceMeshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );

    initCamera();
    _initFaceNet();
  }

  Future<void> _initFaceNet() async {
    await faceNetService.loadModel();
    debugPrint("FaceNet model loaded");
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _faceMeshDetector.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    faceNetService.closeModel();

    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();

    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    await onNewCameraSelected(frontCamera);

    await _controller!.startImageStream(_processCameraImage);
  }

  Future<void> onNewCameraSelected(CameraDescription description) async {
    final previousCameraController = _controller;

    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    await previousCameraController?.dispose();
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    _imageSize = Size(image.width.toDouble(), image.height.toDouble());
    _latestImage = image;

    try {
      final inputImage = _convertToInputImage(image);
      final faces = await _faceMeshDetector.processImage(inputImage);

      setState(() {
        _faces = faces;
      });

      if (faces.isNotEmpty) {
        _latestFace = faces.first;
      }

      if (_screenSize != null && !_isCapturing) {
        final isInside = _checkIfFaceInFrame(_screenSize!);

        if (isInside && faces.isNotEmpty) {
          _captureTimer ??= Timer(const Duration(seconds: 2), () {
            if (!_isCapturing && _latestImage != null && _latestFace != null) {
              _captureAndCropFace(_latestImage!, _latestFace!);
            }
            _captureTimer = null;
          });
        } else {
          _captureTimer?.cancel();
          _captureTimer = null;
        }
      }
    } catch (e) {
      debugPrint("Detection error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _captureAndCropFace(CameraImage image, FaceMesh face) async {
    _isCapturing = true;

    try {
      final rect = face.boundingBox;

      const padding = 100;

      final x = (rect.left - padding).clamp(0, image.width - 1).toInt();
      final y = (rect.top - padding).clamp(0, image.height - 1).toInt();

      final w = (rect.width + padding * 2).clamp(0, image.width - x).toInt();
      final h = (rect.height + padding * 2).clamp(0, image.height - y).toInt();

      final faceImage = _cropFaceFromCameraImage(image, x, y, w, h);

      final embedding = faceNetService.getEmbedding(faceImage);

      final bytes = img.encodeJpg(faceImage);

      await _secureStorageHelper.saveEmbeddingImage(embedding);

      final savedEmbedding = await _secureStorageHelper.getEmbeddingImage();

      if (savedEmbedding != null) {
        final distance = faceNetService.calculateDistance(
          embedding,
          savedEmbedding,
        );

        if (distance < 0.85) {
          context.push(
            "/clockin/preview-page",
            extra: Uint8List.fromList(bytes),
          );
        } else {
          showAboutDialog(
            context: context,
            children: [Text("WAJAH TIDAK SAMA")],
          );
        }
        print("SIMILARITY DISTANCE: $distance");
      }

      print("EMBEDDING: $embedding");
    } catch (e) {
      debugPrint("Crop error: $e");
    }

    await Future.delayed(const Duration(seconds: 2));
    _isCapturing = false;
  }

  img.Image _cropFaceFromCameraImage(
    CameraImage image,
    int x,
    int y,
    int width,
    int height,
  ) {
    img.Image converted = _convertYUV420toImage(image);

    if (_rotation == InputImageRotation.rotation90deg) {
      converted = img.copyRotate(converted, angle: 90);
    } else if (_rotation == InputImageRotation.rotation270deg) {
      converted = img.copyRotate(converted, angle: 270);
    } else if (_rotation == InputImageRotation.rotation180deg) {
      converted = img.copyRotate(converted, angle: 180);
    }

    return img.copyCrop(converted, x: x, y: y, width: width, height: height);
  }

  img.Image _convertYUV420toImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final img.Image imgBuffer = img.Image(width: width, height: height);

    final plane = image.planes[0];

    int pixelIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int pixel = plane.bytes[pixelIndex];
        imgBuffer.setPixelRgb(x, y, pixel, pixel, pixel);
        pixelIndex++;
      }
    }

    return imgBuffer;
  }

  InputImage _convertToInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();

    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final rotation =
        InputImageRotationValue.fromRawValue(
          _controller!.description.sensorOrientation,
        ) ??
        InputImageRotation.rotation0deg;

    _rotation = rotation;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format:
            InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.yuv420,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  bool _checkIfFaceInFrame(Size screenSize) {
    if (_faces.isEmpty || _imageSize == null) return false;

    final face = _faces.first;

    final bool isPortrait =
        _rotation == InputImageRotation.rotation90deg ||
        _rotation == InputImageRotation.rotation270deg;

    final double mappedImageWidth = isPortrait
        ? _imageSize!.height
        : _imageSize!.width;
    final double mappedImageHeight = isPortrait
        ? _imageSize!.width
        : _imageSize!.height;

    final scaleX = screenSize.width / mappedImageWidth;
    final scaleY = screenSize.height / mappedImageHeight;

    final rect = face.boundingBox;
    final faceLeft = screenSize.width - (rect.right * scaleX);
    final faceRight = screenSize.width - (rect.left * scaleX);
    final faceTop = rect.top * scaleY;
    final faceBottom = rect.bottom * scaleY;
    final faceRect = Rect.fromLTRB(faceLeft, faceTop, faceRight, faceBottom);

    const double boxW = 250.0;
    const double boxH = 320.0;
    const double marginBottom = 150.0;

    final double targetLeft = (screenSize.width - boxW) / 2;
    final double targetTop = (screenSize.height - boxH) / 2 - marginBottom;

    final targetRect = Rect.fromLTWH(targetLeft, targetTop, boxW, boxH);

    return targetRect.contains(faceRect.center);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final aspect = 1 / _controller!.value.aspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: aspect,
          child: LayoutBuilder(
            builder: (context, constraints) {
              _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
              final bool isFaceInBox = _checkIfFaceInFrame(_screenSize!);
              return Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_controller!),
                  FaceOverlay(
                    faces: _faces,
                    imageSize: _imageSize,
                    rotation: _rotation,
                    isFaceInBox: isFaceInBox,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FaceOverlay extends StatelessWidget {
  List<FaceMesh> faces;
  final Size? imageSize;
  final InputImageRotation rotation;
  final bool isFaceInBox;

  FaceOverlay({
    super.key,
    required this.faces,
    required this.imageSize,
    required this.rotation,
    required this.isFaceInBox,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isFaceInBox ? Colors.green : Colors.red;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 150),
                  width: 250,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: 250,
            height: 320,
            margin: const EdgeInsets.only(bottom: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor, width: 3),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: CustomPaint(
        //     painter: FaceMeshPainter(faces, imageSize, rotation),
        //   ),
        // ),
      ],
    );
  }
}

class FaceMeshPainter extends CustomPainter {
  final List<FaceMesh> faces;
  final Size? imageSize;
  final InputImageRotation rotation;

  FaceMeshPainter(this.faces, this.imageSize, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize == null) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.5
      ..style = PaintingStyle.fill;

    // CEK ORIENTASI: Jika portrait (90 atau 270 derajat), swap width & height dari raw image
    final bool isPortrait =
        rotation == InputImageRotation.rotation90deg ||
        rotation == InputImageRotation.rotation270deg;

    final double mappedImageWidth = isPortrait
        ? imageSize!.height
        : imageSize!.width;
    final double mappedImageHeight = isPortrait
        ? imageSize!.width
        : imageSize!.height;

    // Hitung skala berdasarkan ukuran gambar yang sudah disesuaikan
    final scaleX = size.width / mappedImageWidth;
    final scaleY = size.height / mappedImageHeight;

    for (final face in faces) {
      for (final point in face.points) {
        // Karena ini kamera depan, koordinat X harus di-mirror
        final x = size.width - (point.x * scaleX);
        final y = point.y * scaleY;

        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FaceMeshPainter oldDelegate) {
    return oldDelegate.faces != faces || oldDelegate.imageSize != imageSize;
  }
}
