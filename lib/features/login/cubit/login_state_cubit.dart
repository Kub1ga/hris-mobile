import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:workmate_mobile/features/login/models/login_state.dart';

part 'login_state_state.dart';

class LoginStateCubit extends Cubit<LoginMethod> {
  LoginStateCubit() : super(LoginMethod.email);

  void changeMethod(LoginMethod value) {
    if (state == value) return;
    emit(value);
  }
}
