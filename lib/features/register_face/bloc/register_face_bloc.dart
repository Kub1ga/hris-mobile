import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image/image.dart' as img;

import '../../../utils/facenet_service.dart';
part 'register_face_event.dart';
part 'register_face_state.dart';

class RegisterFaceBloc extends Bloc<RegisterFaceEvent, RegisterFaceState> {
  late FaceMeshDetector faceMeshDetector;
  final FaceNetService faceNetService = FaceNetService();

  RegisterFaceBloc() : super(RegisterFaceState()) {
    faceMeshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );

    on<InitializeRegisterCamera>(_initializeCamera);
    on<ProcessCameraImage>(_onProcessImage);
    on<SetScreenSize>((event, emit) {
      emit(state.copyWith(screenSize: event.size));
    });
    on<CaptureFace>(_onCaptureFace);
  }

  Future<void> _initializeCamera(
    InitializeRegisterCamera event,
    Emitter<RegisterFaceState> emit,
  ) async {
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

    emit(state.copyWith(controller: controller));
  }

  Future<void> _onProcessImage(
    ProcessCameraImage event,
    Emitter<RegisterFaceState> emit,
  ) async {
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
        log("screenSize: ${state.screenSize}", name: "FACE REGISTER BLOC");
        log("isFaceInside: $isFaceInside", name: "FACE REGISTER BLOC");
      }

      final rotation =
          InputImageRotationValue.fromRawValue(
            state.controller!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      emit(
        state.copyWith(
          faces: faces,
          rotation: rotation,
          imageSize: imageSize,
          latestImage: image,
          latestFace: latestFace,
          isFaceInside: isFaceInside,
        ),
      );
    } catch (e) {
      log("Detection error: $e");
    }
  }

  @override
  Future<void> close() async {
    await state.controller?.dispose();
    faceMeshDetector.close();

    return super.close();
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

  Future<void> _onCaptureFace(
    CaptureFace event,
    Emitter<RegisterFaceState> emit,
  ) async {
    if (state.latestFace == null || state.latestImage == null) return;

    final image = state.latestImage!;
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
    final bytes = img.encodeJpg(faceImage);

    faceNetService.getEmbedding(faceImage);
    emit(state.copyWith(capturedFace: Uint8List.fromList(bytes)));
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
}
