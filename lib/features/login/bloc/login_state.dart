part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  List<Object> get props => [message];
}

final class LoginSuccess extends LoginState {}
