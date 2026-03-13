part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class SubmitedEvent extends RegisterEvent {
  final String companyId;
  final String email;
  final bool isTncAccepted;
  final String password;
  final String phoneNumber;

  const SubmitedEvent({
    required this.companyId,
    required this.email,
    required this.isTncAccepted,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [
    companyId,
    email,
    isTncAccepted,
    password,
    phoneNumber,
  ];
}
