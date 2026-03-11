import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomBorderCheckbox extends StatefulWidget {
  const CustomBorderCheckbox({super.key});

  @override
  State<CustomBorderCheckbox> createState() => _CustomBorderCheckboxState();
}

class _CustomBorderCheckboxState extends State<CustomBorderCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: PurpleColors.purple600, width: 2),
        color: PurpleColors.purple50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 14,
        width: 14,
        child: Transform.scale(
          scale: 0.7,
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
            checkColor: PurpleColors.purple600,
            activeColor: PurpleColors.purple100,
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
