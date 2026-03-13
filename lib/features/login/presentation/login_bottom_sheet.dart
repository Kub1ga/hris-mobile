import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/core/components/main_button.dart';
import 'package:workmate_mobile/core/components/main_form_field.dart';
import 'package:workmate_mobile/core/components/primary_button.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';
import 'package:workmate_mobile/features/login/cubit/login_state_cubit.dart';
import 'package:workmate_mobile/features/login/models/login_state.dart';

import '../../../core/components/custom_border_checkbox.dart';
import '../bloc/login_bloc.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  bool isObscure = true;
  void setObscurePassword() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  bool isRememberMe = false;
  void setRememberMe() {
    setState(() {
      isRememberMe = !isRememberMe;
    });
  }

  void clearErrors() {
    setState(() {
      isEmailError = false;
      emailErrorText = "";
      isPasswordError = false;
      passwordErrorText = "";
      _emailController.clear();
      _passwordController.clear();
      _employeeIdController.clear();
    });
  }

  bool isEmailError = false;
  String emailErrorText = "";

  void handleSignIn(LoginMethod method) {
    if (method == LoginMethod.email) {
      log("Login with EMAIL: ${_emailController.text}");
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
          loginMethod: method,
        ),
      );
    } else if (method == LoginMethod.employeeId) {
      log("Login with EMPLOYEE ID: ${_employeeIdController.text}");
      context.read<LoginBloc>().add(
        LoginSubmitted(
          employeeId: _employeeIdController.text,
          password: _passwordController.text,
          loginMethod: method,
        ),
      );
    }
  }

  bool isPasswordError = false;
  String passwordErrorText = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 0),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: HeadlineText.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Sign in to my account",
                style: LabelText.labelLarge.copyWith(color: GrayColors.grey600),
              ),
              const SizedBox(height: 24),
              ...[
                BlocBuilder<LoginStateCubit, LoginMethod>(
                  builder: (context, state) {
                    return BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginError) {
                          setState(() {
                            isEmailError = true;
                            emailErrorText = state.message;
                          });
                        } else if (state is LoginSuccess) {
                          context.pushReplacement('/home');
                        }
                      },
                      child: _buildForm(state),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Column _buildForm(LoginMethod method) {
    switch (method) {
      case LoginMethod.email:
        return Column(
          children: [
            MainFormField(
              title: "Email",
              placeholder: "My Email",
              svgPath: "assets/icons/email.svg",
              controller: _emailController,
              isError: isEmailError,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 24),
            MainFormField(
              title: "Password",
              placeholder: "Password",
              svgPath: "assets/icons/biometric.svg",
              suffixSvgPath: "assets/icons/eyes_closed.svg",
              obscureText: isObscure,
              onSuffixTap: () {
                setObscurePassword();
              },
              controller: _passwordController,
              isError: isPasswordError,
              errorText: passwordErrorText,
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                CustomBorderCheckbox(),
                Text("Remember Me", style: BodyText.bodySmall),
                const Spacer(),
                Text(
                  "Forgot Password",
                  style: BodyText.bodySmall.copyWith(
                    color: PurpleColors.purple600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return state is LoginLoading
                      ? MainButton(
                          text: "Sign In",
                          onTap: () {},
                          isDisabled: true,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        )
                      : MainButton(
                          text: "Sign In",
                          onTap: () {
                            handleSignIn(method);
                          },
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        );
                },
              ),
            ),
            const SizedBox(height: 32),
            Row(
              spacing: 16,
              children: [
                Expanded(child: Divider(color: GrayColors.grey300)),
                Text("OR"),
                Expanded(child: Divider(color: GrayColors.grey300)),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/employee_id.svg",
              text: "Sign in With Employee ID",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(
                  LoginMethod.employeeId,
                );
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/phone.svg",
              text: "Sign in With Phone",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(LoginMethod.phone);
              },
            ),
            const SizedBox(height: 24),
            _buildRichText(),
          ],
        );
      case LoginMethod.phone:
        return Column(
          children: [
            MainFormField(
              title: "Phone Number",
              placeholder: "Your Phone Number",
              svgPath: "assets/icons/email.svg",
              controller: _emailController,
              isError: isEmailError,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                CustomBorderCheckbox(),
                Text("Remember Me", style: BodyText.bodySmall),
                const Spacer(),
                Text(
                  "Forgot Password",
                  style: BodyText.bodySmall.copyWith(
                    color: PurpleColors.purple600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                text: "Sign In",
                onTap: () {
                  handleSignIn(method);
                },
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              spacing: 16,
              children: [
                Expanded(child: Divider(color: GrayColors.grey300)),
                Text("OR"),
                Expanded(child: Divider(color: GrayColors.grey300)),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/employee_id.svg",
              text: "Sign in With Employee ID",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(
                  LoginMethod.employeeId,
                );
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/mail_bold.svg",
              text: "Sign in With Email",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(LoginMethod.email);
              },
            ),
            const SizedBox(height: 22),
            _buildRichText(),
          ],
        );
      case LoginMethod.employeeId:
        return Column(
          children: [
            MainFormField(
              title: "Employee ID",
              placeholder: "My Employee ID",
              svgPath: "assets/icons/email.svg",
              controller: _employeeIdController,
              isError: isEmailError,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 24),
            MainFormField(
              title: "Password",
              placeholder: "Password",
              svgPath: "assets/icons/biometric.svg",
              suffixSvgPath: "assets/icons/eyes_closed.svg",
              obscureText: isObscure,
              onSuffixTap: () {
                setObscurePassword();
              },
              controller: _passwordController,
              isError: isPasswordError,
              errorText: passwordErrorText,
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                CustomBorderCheckbox(),
                Text("Remember Me", style: BodyText.bodySmall),
                const Spacer(),
                Text(
                  "Forgot Password",
                  style: BodyText.bodySmall.copyWith(
                    color: PurpleColors.purple600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                text: "Sign In",
                onTap: () {
                  log("LOGIN WITH EMPLOYEE ID...", name: "LOGIN BOTTOM SHEET");
                  handleSignIn(method);
                },
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              spacing: 16,
              children: [
                Expanded(child: Divider(color: GrayColors.grey300)),
                Text("OR"),
                Expanded(child: Divider(color: GrayColors.grey300)),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/employee_id.svg",
              text: "Sign in With Email",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(LoginMethod.email);
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              prefixPath: "assets/icons/phone.svg",
              text: "Sign in With Phone",
              onTap: () {
                clearErrors();
                context.read<LoginStateCubit>().changeMethod(LoginMethod.phone);
              },
            ),
            const SizedBox(height: 22),
            _buildRichText(),
          ],
        );
    }
  }

  RichText _buildRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: LabelText.labelSmall.copyWith(
              // fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "Sign Up Here",
                style: LabelText.labelSmall.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: PurpleColors.purple500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
