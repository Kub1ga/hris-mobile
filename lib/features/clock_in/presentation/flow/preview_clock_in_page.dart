import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/main_button.dart';
import '../../../../core/theme/colors.dart';

class PreviewClockInPage extends StatelessWidget {
  final Uint8List imageBytes;
  const PreviewClockInPage({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F3F8),
      appBar: AppBar(
        title: Text("Selfie To Clock In"),
        centerTitle: true,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PurpleColors.purple50,
            ),
            child: SvgPicture.asset("assets/icons/back_icon.svg"),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 16),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              width: 334,
              height: 440,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
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
        child: MainButton(onTap: () {}, text: "Clock In"),
      ),
    );
  }
}
