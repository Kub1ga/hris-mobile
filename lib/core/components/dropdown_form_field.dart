import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

import '../theme/colors.dart';

class DropdownFormField extends StatefulWidget {
  final TextEditingController controller;
  const DropdownFormField({super.key, required this.controller});

  @override
  State<DropdownFormField> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        spacing: 4,
        crossAxisAlignment: .start,
        children: [
          Text("Phone Number", style: BodyText.bodySmall),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: GrayColors.grey400, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: DropdownButtonFormField(
                    initialValue: "62",
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: InputBorder.none,
                    ),
                    style: BodyText.bodyMedium.copyWith(color: Colors.black),
                    icon: Transform.rotate(
                      angle: 4.7,
                      child: SvgPicture.asset("assets/icons/back_icon.svg"),
                    ),
                    items: [
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: "62",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: const Text(
                            "INA (+62)",
                            style: BodyText.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 4,
                  child: TextFormField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hint: Text(
                        "+62 0000 0000 0000",
                        style: BodyText.bodyMedium.copyWith(
                          color: GrayColors.grey400,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
