import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmate_mobile/features/auth/login/models/login_state.dart';

import '../../../../utils/secure_storage.dart';
import '../../repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final SecureStorageHelper _secureStorage = SecureStorageHelper();
  final SharedPreferences prefs;
  LoginBloc({required this.authRepository, required this.prefs})
    : super(LoginInitial()) {
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
            if (event.isRememberMe) {
              await prefs.setBool("remember_me", true);
            } else {
              await prefs.remove("remember_me");
              emit(UnAuthenticated());
            }
            emit(Authenticated());
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
            if (event.isRememberMe) {
              await prefs.setBool("remember_me", true);
            } else {
              await prefs.remove("remember_me");
              emit(UnAuthenticated());
            }
            emit(Authenticated());
          } else {
            emit(LoginError("Token tidak ditemukan"));
          }
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      }
    });

    on<CheckRememberMe>((event, emit) async {
      final remember = prefs.getBool("remember_me") ?? false;

      if (!remember) {
        emit(UnAuthenticated());
        return;
      }

      final token = await _secureStorage.getToken();

      if (token != null) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    });
  }
}
