import 'package:flutter/material.dart';
import 'package:workmate_mobile/core/components/main_button.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F3F8),
      body: Stack(
        children: [
          Container(
            height: 233,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff7155FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Challanges Awaiting",
                          style: HeadlineText.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Let’s tackle your to do list",
                          style: LabelText.labelLarge.copyWith(
                            color: PurpleColors.purple200,
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/icons/task-illus.png",
                      height: 78,
                      width: 94,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.only(right: 12, left: 12),
                  width: double.infinity,
                  height: 210,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: GrayColors.grey300, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffAA9FFE).withAlpha(0),
              offset: const Offset(0, -105),
              spreadRadius: 0,
              blurRadius: 29,
            ),
            BoxShadow(
              color: const Color(0xffAA9FFE).withAlpha(1),
              offset: const Offset(0, -67),
              spreadRadius: 0,
              blurRadius: 27,
            ),
            BoxShadow(
              color: const Color(0xffAA9FFE).withAlpha(5),
              offset: const Offset(0, -38),
              spreadRadius: 0,
              blurRadius: 23,
            ),
            BoxShadow(
              color: const Color(0xffAA9FFE).withAlpha(9),
              offset: const Offset(0, -17),
              spreadRadius: 0,
              blurRadius: 17,
            ),
            BoxShadow(
              color: const Color(0xffAA9FFE).withAlpha(80),
              offset: const Offset(0, -4),
              spreadRadius: 9,
              blurRadius: 100,
            ),
          ],
        ),
        child: MainButton(onTap: () {}, text: "Create Task"),
      ),
    );
  }
}
