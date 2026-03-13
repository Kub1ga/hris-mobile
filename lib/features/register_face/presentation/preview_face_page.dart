import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/core/components/main_button.dart';
import 'package:workmate_mobile/features/repository/attendance_repository.dart';
import 'package:workmate_mobile/features/auth/repository/auth_repository.dart';
import 'package:workmate_mobile/utils/dio_client.dart';

import '../../clock_in/attendance/bloc/attendance_bloc.dart';

class PreviewFacePage extends StatefulWidget {
  final Uint8List image;
  const PreviewFacePage({super.key, required this.image});

  @override
  State<PreviewFacePage> createState() => _PreviewFacePageState();
}

class _PreviewFacePageState extends State<PreviewFacePage> {
  Dio dio = DioClient().dio;
  Future<void> uploadSelfie() async {
    final dio = Dio();

    final random = math.Random();
    final publicId = (100 + random.nextInt(900)).toString();

    final formData = FormData.fromMap({
      "upload_preset": "hris_attendance_selfie_preset",
      "public_id": publicId,
      "folder": "attendance/selfies",
      "file": MultipartFile.fromBytes(widget.image, filename: "$publicId.jpg"),
    });

    final response = await dio.post(
      "https://api.cloudinary.com/v1_1/dmvot15pm/upload",
      data: formData,
    );

    if (response.statusCode == 200) {
      log("status: ${response.statusCode}", name: "CLOUDINARY");
      log("data: ${response.data}", name: "CLOUDINARY");
      final url = response.data['url'];
      await context.read<AttendanceRepository>().registerSelfie(url: url);

      return response.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        spacing: 16,
        children: [
          Center(child: Image.memory(widget.image)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: MainButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              onTap: () async {
                await uploadSelfie();
                if (context.mounted) {
                  context.read<AttendanceBloc>().add(CheckFaceRecog());
                }
              },
              text: "DONE",
            ),
          ),
        ],
      ),
    );
  }
}
