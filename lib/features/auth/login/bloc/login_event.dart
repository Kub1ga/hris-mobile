part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  final String? email;
  final String? password;
  final String? employeeId;
  final LoginMethod loginMethod;
  final bool isRememberMe;

  const LoginSubmitted({
    this.email,
    this.password,
    this.employeeId,
    required this.loginMethod,
    this.isRememberMe = false,
  });

  @override
  List<Object> get props => [
    email ?? '',
    password ?? '',
    employeeId ?? '',
    loginMethod,
    isRememberMe,
  ];
}

final class CheckRememberMe extends LoginEvent {
  const CheckRememberMe();
}
