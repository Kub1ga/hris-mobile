import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/core/components/main_button.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 85, 32, 32),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please Register Your Face First",
                style: HeadlineText.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Almost there! Please register your face to continue",
                style: LabelText.labelLarge.copyWith(color: GrayColors.grey600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  text: "Register Face",
                  onTap: () {
                    context.pop();
                    context.push("/register-face");
                  },
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),

        /// gambar floating
        Positioned(
          top: -40,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: PurpleColors.purple600,
              boxShadow: [
                BoxShadow(
                  color: PurpleColors.purple400,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                "assets/icons/biometric.svg",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
