import 'package:flutter/material.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

class MainButton extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String? text;
  final bool? isDisabled;
  final VoidCallback onTap;
  const MainButton({
    super.key,
    this.padding,
    this.text,
    required this.onTap,
    this.isDisabled,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isDisabled == true ? 0.4 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: widget.onTap,
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff5B2ED4),
              gradient: LinearGradient(
                colors: [
                  Color(0xff8862F2),
                  Color(0xff7544FC),
                  Color(0xff5B2ED4),
                ],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Color(0xff8862F2)),
            ),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff8862F2),
                    Color(0xff7544FC),
                    Color(0xff5B2ED4),
                  ],
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  widget.text ?? "DUMMY",
                  style: LabelText.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
