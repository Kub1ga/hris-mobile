part of 'register_face_bloc.dart';

abstract class RegisterFaceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeRegisterCamera extends RegisterFaceEvent {}

class ProcessCameraImage extends RegisterFaceEvent {
  final CameraImage image;

  ProcessCameraImage(this.image);

  @override
  List<Object?> get props => [image];
}

class SetScreenSize extends RegisterFaceEvent {
  final Size size;

  SetScreenSize(this.size);

  @override
  List<Object> get props => [size];
}

class CaptureFace extends RegisterFaceEvent {}
