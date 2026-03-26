import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:workmate_mobile/features/auth/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepository authRepository = AuthRepository();
  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<SubmitedEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authRepository.register(
          email: event.email,
          phoneNumber: event.phoneNumber,
          companyId: event.companyId,
          password: event.password,
          isTncAccepted: event.isTncAccepted,
        );
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterError());
      }
    });

    on<ReqOtpEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authRepository.requestOtp(email: event.email);
        emit(ReqOtpSuccess());
      } catch (e) {
        emit(ReqOtpError());
      }
    });
  }
}
