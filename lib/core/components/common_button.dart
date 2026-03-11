import 'package:flutter/material.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

class CommonButton extends StatefulWidget {
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  const CommonButton({super.key, this.padding, this.onTap});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: PurpleColors.purple600,
        ),
        child: Text(
          "Join Meet",
          style: LabelText.labelSmall.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
