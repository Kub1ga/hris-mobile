import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:workmate_mobile/features/clock_in/model/face_clockin_status.dart';

import '../../face_clock_in_bloc/face_clockin_bloc.dart';

class SelfieClockInPage extends StatefulWidget {
  const SelfieClockInPage({super.key});

  @override
  State<SelfieClockInPage> createState() => _SelfieClockInPageState();
}

class _SelfieClockInPageState extends State<SelfieClockInPage>
    with WidgetsBindingObserver {
  late FaceMeshDetector _faceMeshDetector;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _faceMeshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      context.read<FaceClockinBloc>().add(SetScreenSize(size));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _faceMeshDetector.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FaceClockinBloc, FaceClockinState>(
      listenWhen: (previous, current) => previous.status != current.status,

      listener: (context, state) {
        if (state.status == FaceClockinStatus.success &&
            state.capturedImage != null) {
          context.pushReplacement(
            "/clockin/preview-page",
            extra: state.capturedImage,
          );
        }

        if (state.status == FaceClockinStatus.notMatch) {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(title: Text("WAJAH TIDAK SAMA")),
          );
        }
      },
      child: BlocBuilder<FaceClockinBloc, FaceClockinState>(
        builder: (context, state) {
          if (state.controller == null || state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final aspect = 1 / state.controller!.value.aspectRatio;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: AspectRatio(
                aspectRatio: aspect,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(state.controller!),

                        FaceOverlay(
                          faces: state.faces,
                          imageSize: state.imageSize,
                          rotation: state.rotation,
                          isFaceInBox: state.isFaceInBox,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FaceOverlay extends StatelessWidget {
  final List<FaceMesh> faces;
  final Size? imageSize;
  final InputImageRotation rotation;
  final bool isFaceInBox;

  const FaceOverlay({
    super.key,
    required this.faces,
    required this.imageSize,
    required this.rotation,
    required this.isFaceInBox,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isFaceInBox ? Colors.green : Colors.red;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 150),
                  width: 250,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: 250,
            height: 320,
            margin: const EdgeInsets.only(bottom: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}
