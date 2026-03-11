import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

class MainFormField extends StatefulWidget {
  final String placeholder;
  final String? svgPath;
  final String? title;
  final String? suffixSvgPath;
  final bool? obscureText;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final bool? isError;
  final String? errorText;
  const MainFormField({
    super.key,
    this.placeholder = "",
    this.svgPath,
    this.title,
    this.suffixSvgPath,
    this.obscureText,
    this.onSuffixTap,
    this.controller,
    this.isError,
    this.errorText,
  });

  @override
  State<MainFormField> createState() => _MainFormFieldState();
}

class _MainFormFieldState extends State<MainFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(widget.title ?? "", style: BodyText.bodySmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isError == true ? Colors.red : GrayColors.grey400,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText ?? false,
            style: BodyText.bodyMedium,
            decoration: InputDecoration(
              icon: widget.svgPath != null
                  ? SvgPicture.asset(widget.svgPath!)
                  : null,
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: BodyText.bodyMedium.copyWith(
                color: GrayColors.grey400,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 14,
                minWidth: 14,
              ),
              suffixIcon: widget.suffixSvgPath != null || widget.isError == true
                  ? Row(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.suffixSvgPath != null)
                          InkWell(
                            onTap: widget.onSuffixTap,
                            borderRadius: BorderRadius.circular(100),
                            child: SvgPicture.asset(widget.suffixSvgPath!),
                          ),
                        if (widget.isError != null && widget.isError == true)
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 22,
                            fontWeight: FontWeight.w100,
                          ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
        if (widget.isError != null && widget.isError == true)
          Text(
            widget.errorText!,
            style: BodyText.bodySmall.copyWith(color: Colors.red),
          ),
      ],
    );
  }
}
