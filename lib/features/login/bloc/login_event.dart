part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  final String? username;
  final String? password;
  final String? employeeId;
  final LoginMethod loginMethod;

  const LoginSubmitted({
    this.username,
    this.password,
    this.employeeId,
    required this.loginMethod,
  });

  @override
  List<Object> get props => [
    username ?? '',
    password ?? '',
    employeeId ?? '',
    loginMethod,
  ];
}
