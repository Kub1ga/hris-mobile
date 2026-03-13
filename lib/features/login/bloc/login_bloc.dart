import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:workmate_mobile/features/login/models/login_state.dart';

import '../../../utils/secure_storage.dart';
import '../../repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final SecureStorageHelper _secureStorage = SecureStorageHelper();
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      if (event.loginMethod.name == "email") {
        try {
          final result = await authRepository.login(
            event.email ?? "",
            event.password ?? "",
          );
          final String? token = result['token'];
          if (token != null) {
            await _secureStorage.saveToken(token.toString());
            emit(LoginSuccess());
          } else {
            emit(LoginError("Token tidak ditemukan"));
          }
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      } else if (event.loginMethod.name == "employeeId") {
        try {
          final result = await authRepository.loginWithEmployeeId(
            event.employeeId ?? "",
            event.password ?? "",
          );
          final String? token = result['token'];
          log(token ?? "TOKEN NULL", name: "LOGIN BLOC");
          if (token != null) {
            await _secureStorage.saveToken(token.toString());
            emit(LoginSuccess());
          } else {
            emit(LoginError("Token tidak ditemukan"));
          }
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      }
    });
  }
}
