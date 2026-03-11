import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image/image.dart' as img;
import 'package:workmate_mobile/features/clock_in/model/face_clockin_status.dart';
import 'package:workmate_mobile/utils/facenet_service.dart';
import 'package:workmate_mobile/utils/secure_storage.dart';

part 'face_clockin_event.dart';
part 'face_clockin_state.dart';

class FaceClockinBloc extends Bloc<FaceClockinEvent, FaceClockinState> {
  late FaceMeshDetector faceMeshDetector;
  Timer? _captureTimer;
  final FaceNetService faceNetService = FaceNetService();
  final SecureStorageHelper secureStorageHelper = SecureStorageHelper();
  final FaceClockinStatus status = FaceClockinStatus.idle;

  FaceClockinBloc() : super(const FaceClockinState()) {
    faceMeshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );

    on<InitializeCamera>(_onInitializeCamera);
    on<ProcessCameraImage>(_onProcessImage);
    on<SetScreenSize>((event, emit) {
      emit(state.copyWith(screenSize: event.size));
    });
    on<CaptureFace>(_onCaptureFace);
  }

  @override
  Future<void> close() async {
    await state.controller?.dispose();
    faceMeshDetector.close();
    faceNetService.closeModel();
    return super.close();
  }

  Future<void> _onInitializeCamera(
    InitializeCamera event,
    Emitter<FaceClockinState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await controller.initialize();

    await controller.startImageStream((image) {
      add(ProcessCameraImage(image));
    });

    await faceNetService.loadModel();

    emit(state.copyWith(controller: controller, isLoading: false));
  }

  Future<void> _onProcessImage(
    ProcessCameraImage event,
    Emitter<FaceClockinState> emit,
  ) async {
    if (state.isDetecting) return;

    emit(state.copyWith(isDetecting: true));

    final image = event.image;

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    try {
      final inputImage = _convertToInputImage(image, state.controller!);
      final faces = await faceMeshDetector.processImage(inputImage);

      FaceMesh? latestFace;
      if (faces.isNotEmpty) {
        latestFace = faces.first;
      }

      bool isFaceInside = false;

      if (state.screenSize != null) {
        isFaceInside = _checkIfFaceInFrame(
          state.screenSize!,
          faces,
          imageSize,
          state.rotation,
        );
        log("screenSize: ${state.screenSize}", name: "FACE CLOCKIN BLOC");
        log("isFaceInside: $isFaceInside", name: "FACE CLOCKIN BLOC");
      }
      final rotation =
          InputImageRotationValue.fromRawValue(
            state.controller!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      emit(
        state.copyWith(
          faces: faces,
          imageSize: imageSize,
          rotation: rotation,
          latestImage: image,
          latestFace: latestFace,
          isFaceInBox: isFaceInside,
        ),
      );

      /// start timer capture
      if (isFaceInside && latestFace != null) {
        _captureTimer ??= Timer(const Duration(seconds: 2), () {
          log("CAPTURE TRIGGERED");
          if (!isClosed &&
              state.latestImage != null &&
              state.latestFace != null) {
            add(CaptureFace(state.latestImage!));
          }
          _captureTimer = null;
        });
      } else {
        _captureTimer?.cancel();
        _captureTimer = null;
      }
    } catch (e) {
      log("Detection error: $e");
    }

    emit(state.copyWith(isDetecting: false));
  }

  Future<void> _onCaptureFace(
    CaptureFace event,
    Emitter<FaceClockinState> emit,
  ) async {
    if (state.latestFace == null) return;

    emit(state.copyWith(isCapturing: true));

    try {
      final image = event.image;
      final face = state.latestFace!;
      final rect = face.boundingBox;

      const padding = 100;

      final x = (rect.left - padding).clamp(0, image.width - 1).toInt();
      final y = (rect.top - padding).clamp(0, image.height - 1).toInt();

      final w = (rect.width + padding * 2).clamp(0, image.width - x).toInt();
      final h = (rect.height + padding * 2).clamp(0, image.height - y).toInt();

      final faceImage = _cropFaceFromCameraImage(
        image,
        x,
        y,
        w,
        h,
        state.rotation,
      );

      /// generate embedding
      final embedding = faceNetService.getEmbedding(faceImage);

      final bytes = img.encodeJpg(faceImage);

      await secureStorageHelper.saveEmbeddingImage(embedding);

      final savedEmbedding = await secureStorageHelper.getEmbeddingImage();

      if (savedEmbedding != null) {
        final distance = faceNetService.calculateDistance(
          embedding,
          savedEmbedding,
        );

        log("SIMILARITY: $distance");

        if (distance < 0.9) {
          emit(
            state.copyWith(
              capturedImage: Uint8List.fromList(bytes),
              status: FaceClockinStatus.success,
            ),
          );
        } else {
          emit(state.copyWith(status: FaceClockinStatus.notMatch));
          emit(state.copyWith(status: FaceClockinStatus.detecting));
        }
      }
    } catch (e) {
      log("Capture error: $e");
    }

    emit(state.copyWith(isCapturing: false));
  }

  img.Image _cropFaceFromCameraImage(
    CameraImage image,
    int x,
    int y,
    int width,
    int height,
    InputImageRotation rotation,
  ) {
    img.Image converted = _convertYUV420toImage(image);

    if (rotation == InputImageRotation.rotation90deg) {
      converted = img.copyRotate(converted, angle: 90);
    } else if (rotation == InputImageRotation.rotation270deg) {
      converted = img.copyRotate(converted, angle: 270);
    } else if (rotation == InputImageRotation.rotation180deg) {
      converted = img.copyRotate(converted, angle: 180);
    }

    return img.copyCrop(converted, x: x, y: y, width: width, height: height);
  }

  img.Image _convertYUV420toImage(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final imgBuffer = img.Image(width: width, height: height);

    final plane = image.planes[0];

    int pixelIndex = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = plane.bytes[pixelIndex];

        imgBuffer.setPixelRgb(x, y, pixel, pixel, pixel);

        pixelIndex++;
      }
    }

    return imgBuffer;
  }

  bool _checkIfFaceInFrame(
    Size screenSize,
    List<FaceMesh> faces,
    Size imageSize,
    InputImageRotation rotation,
  ) {
    if (faces.isEmpty) return false;

    final face = faces.first;

    final bool isPortrait =
        rotation == InputImageRotation.rotation90deg ||
        rotation == InputImageRotation.rotation270deg;

    final double mappedImageWidth = isPortrait
        ? imageSize.height
        : imageSize.width;

    final double mappedImageHeight = isPortrait
        ? imageSize.width
        : imageSize.height;

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

  InputImage _convertToInputImage(
    CameraImage image,
    CameraController controller,
  ) {
    final WriteBuffer allBytes = WriteBuffer();

    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final rotation =
        InputImageRotationValue.fromRawValue(
          controller.description.sensorOrientation,
        ) ??
        InputImageRotation.rotation0deg;

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
}
