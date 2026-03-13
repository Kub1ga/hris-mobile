part of 'register_face_bloc.dart';

class RegisterFaceState extends Equatable {
  final CameraController? controller;
  final List<FaceMesh>? faces;
  final Size? screenSize;
  final Size? imageSize;
  final CameraImage? latestImage;
  final InputImageRotation rotation;
  final FaceMesh? latestFace;
  final bool isFaceInside;
  final Uint8List? capturedFace;

  const RegisterFaceState({
    this.controller,
    this.faces,
    this.screenSize,
    this.imageSize,
    this.latestImage,
    this.rotation = InputImageRotation.rotation0deg,
    this.latestFace,
    this.isFaceInside = false,
    this.capturedFace,
  });

  RegisterFaceState copyWith({
    CameraController? controller,
    List<FaceMesh>? faces,
    Size? screenSize,
    Size? imageSize,
    CameraImage? latestImage,
    InputImageRotation? rotation,
    FaceMesh? latestFace,
    bool? isFaceInside,
    Uint8List? capturedFace,
  }) {
    return RegisterFaceState(
      controller: controller ?? this.controller,
      faces: faces ?? this.faces,
      screenSize: screenSize ?? this.screenSize,
      imageSize: imageSize ?? this.imageSize,
      latestImage: latestImage ?? this.latestImage,
      rotation: rotation ?? this.rotation,
      latestFace: latestFace ?? this.latestFace,
      isFaceInside: isFaceInside ?? this.isFaceInside,
      capturedFace: capturedFace ?? this.capturedFace,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    faces,
    screenSize,
    rotation,
    imageSize,
    latestImage,
    latestFace,
    isFaceInside,
    capturedFace,
  ];
}
