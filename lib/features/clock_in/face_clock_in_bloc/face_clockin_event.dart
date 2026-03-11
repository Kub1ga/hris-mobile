part of 'face_clockin_bloc.dart';

abstract class FaceClockinEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCamera extends FaceClockinEvent {}

class ProcessCameraImage extends FaceClockinEvent {
  final CameraImage image;

  ProcessCameraImage(this.image);

  @override
  List<Object?> get props => [image];
}

class CaptureFace extends FaceClockinEvent {
  final CameraImage image;

  CaptureFace(this.image);
}

class SetScreenSize extends FaceClockinEvent {
  final Size size;

  SetScreenSize(this.size);

  @override
  List<Object> get props => [size];
}
