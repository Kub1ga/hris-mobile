import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/face_recog_status.dart';

class FaceRecogStatusCubit extends Cubit<FaceRecogStatus> {
  FaceRecogStatusCubit() : super(FaceRecogStatus.error);

  void changeFaceRecogStatus(FaceRecogStatus status) {
    if (state == status) return;
    emit(status);
    log(status.name, name: "FACE RECOG STATUS");
  }
}
