part of 'face_clockin_bloc.dart';

class FaceClockinState extends Equatable {
  final CameraController? controller;
  final List<FaceMesh> faces;
  final Size? imageSize;
  final InputImageRotation rotation;
  final bool isFaceInBox;
  final bool isLoading;
  final bool isDetecting;
  final CameraImage? latestImage;
  final FaceMesh? latestFace;
  final Size? screenSize;
  final Uint8List? capturedImage;
  final FaceClockinStatus? status;

  const FaceClockinState({
    this.controller,
    this.faces = const [],
    this.imageSize,
    this.rotation = InputImageRotation.rotation0deg,
    this.isFaceInBox = false,
    this.isLoading = true,
    this.isDetecting = false,
    this.latestFace,
    this.latestImage,
    this.screenSize,
    this.capturedImage,
    this.status,
  });

  FaceClockinState copyWith({
    CameraController? controller,
    List<FaceMesh>? faces,
    Size? imageSize,
    InputImageRotation? rotation,
    bool? isFaceInBox,
    bool? isLoading,
    bool? isCapturing,
    bool? isDetecting,
    CameraImage? latestImage,
    FaceMesh? latestFace,
    Size? screenSize,
    bool? isFaceMatch,
    Uint8List? capturedImage,
    FaceClockinStatus? status,
  }) {
    return FaceClockinState(
      controller: controller ?? this.controller,
      faces: faces ?? this.faces,
      imageSize: imageSize ?? this.imageSize,
      rotation: rotation ?? this.rotation,
      isFaceInBox: isFaceInBox ?? this.isFaceInBox,
      isLoading: isLoading ?? this.isLoading,
      isDetecting: isDetecting ?? this.isDetecting,
      latestFace: latestFace ?? this.latestFace,
      latestImage: latestImage ?? this.latestImage,
      screenSize: screenSize ?? this.screenSize,
      capturedImage: capturedImage ?? this.capturedImage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    faces,
    imageSize,
    isDetecting,
    isLoading,
    isFaceInBox,
    rotation,
    latestFace,
    latestImage,
    screenSize,
    capturedImage,
    status,
  ];
}
