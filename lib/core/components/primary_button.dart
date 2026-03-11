import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

class PrimaryButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? text;
  final String? prefixPath;
  const PrimaryButton({
    super.key,
    this.padding,
    this.onTap,
    this.text,
    this.prefixPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: PurpleColors.purple600),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixPath != null) SvgPicture.asset(prefixPath!),
              Text(
                text ?? "DUMMY",
                style: LabelText.labelLarge.copyWith(
                  color: PurpleColors.purple600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
