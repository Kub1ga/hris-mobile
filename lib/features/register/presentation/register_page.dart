import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmate_mobile/core/components/dropdown_form_field.dart';
import 'package:workmate_mobile/core/components/main_button.dart';
import 'package:workmate_mobile/core/components/main_form_field.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

import '../../../core/components/custom_border_checkbox.dart';
import '../../login/bloc/login_bloc.dart';
import '../bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void handleRegister() {
    context.read<RegisterBloc>().add(
      SubmitedEvent(
        companyId: _companyIdController.text,
        email: _emailController.text,
        isTncAccepted: true,
        password: _passwordController.text,
        phoneNumber: _phoneController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 88),
                Image.asset(
                  "assets/icons/workmate_icon.png",
                  height: 56,
                  width: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  "Work Mate",
                  style: DisplayText.displayLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Register Using Your Credentials",
                  style: LabelText.labelMedium.copyWith(
                    color: GrayColors.grey400,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: MainFormField(
                    title: "Email",
                    controller: _emailController,
                    placeholder: "Enter Your Email",
                    svgPath: "assets/icons/email.svg",
                  ),
                ),
                const SizedBox(height: 16),
                DropdownFormField(controller: _phoneController),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: MainFormField(
                    title: "Company ID",
                    controller: _companyIdController,
                    placeholder: "Enter Company ID",
                    svgPath: "assets/icons/email.svg",
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: MainFormField(
                    title: "Password",
                    controller: _passwordController,
                    placeholder: "Your Password",
                    suffixSvgPath: "assets/icons/eyes_closed.svg",
                    svgPath: "assets/icons/biometric.svg",
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: MainFormField(
                    title: "Confirm Password",
                    controller: _confirmPasswordController,
                    placeholder: "Confirm Your Password",
                    suffixSvgPath: "assets/icons/eyes_closed.svg",
                    svgPath: "assets/icons/biometric.svg",
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: .center,
                    children: [CustomBorderCheckbox(), _buildRichText()],
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterError) {
                        log("ERROR", name: "REGISTER PAGE");
                      }
                    },
                    child: MainButton(
                      text: "Sign Up",
                      isDisabled: state == RegisterLoading(),
                      onTap: () {
                        handleRegister();
                      },
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 73),
              ],
            ),
          );
        },
      ),
    );
  }

  RichText _buildRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "I agree with ",
            style: LabelText.labelSmall.copyWith(
              // fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "terms & conditions ",
                style: LabelText.labelSmall.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: PurpleColors.purple500,
                ),
              ),
              TextSpan(
                text: "and ",
                style: LabelText.labelSmall.copyWith(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "privacy policy",
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
