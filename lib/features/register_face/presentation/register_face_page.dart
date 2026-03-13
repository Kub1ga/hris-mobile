import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:workmate_mobile/features/clock_in/presentation/flow/selfie_clock_in_page.dart';

import '../bloc/register_face_bloc.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage>
    with WidgetsBindingObserver {
  late FaceMeshDetector _faceMeshDetector;

  @override
  void initState() {
    super.initState();
    _faceMeshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      context.read<RegisterFaceBloc>().add(SetScreenSize(size));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _faceMeshDetector.close();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterFaceBloc, RegisterFaceState>(
      listenWhen: (previous, current) =>
          previous.capturedFace != current.capturedFace,
      listener: (context, state) {
        if (state.capturedFace != null) {
          context.pushReplacement(
            "/register-face/preview-face",
            extra: state.capturedFace,
          );
        }
      },
      child: BlocBuilder<RegisterFaceBloc, RegisterFaceState>(
        builder: (context, state) {
          if (state.controller == null) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // if (state.capturedFace != null) {
          //   return Scaffold(
          //     body: Center(child: Image.memory(state.capturedFace!)),
          //   );
          // }
          final aspect = 1 / state.controller!.value.aspectRatio;
          return Scaffold(
            backgroundColor: Colors.black,
            body: state.controller == null
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: aspect,
                            child: Stack(
                              // fit: StackFit.expand,
                              children: [
                                CameraPreview(state.controller!),
                                FaceOverlay(
                                  faces: state.faces ?? [],
                                  imageSize: state.imageSize,
                                  rotation: state.rotation,
                                  isFaceInBox: state.isFaceInside,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            context.read<RegisterFaceBloc>().add(CaptureFace());
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: state.isFaceInside
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
