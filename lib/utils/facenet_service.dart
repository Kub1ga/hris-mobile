import 'dart:developer';
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceNetService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/mobilefacenet.tflite',
    );
  }

  double calculateDistance(List<double> e1, List<double> e2) {
    double sum = 0;

    for (int i = 0; i < e1.length; i++) {
      sum += math.pow(e1[i] - e2[i], 2);
    }

    return math.sqrt(sum);
  }

  Future<void> closeModel() async {
    log("CLOSING INTERPRETER", name: "FACENET SERVICE");
    _interpreter?.close();
  }

  List<double> _preprocess(img.Image image) {
    final resized = img.copyResize(image, width: 112, height: 112);

    List<double> input = [];

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);

        input.add((pixel.r - 128) / 128);
        input.add((pixel.g - 128) / 128);
        input.add((pixel.b - 128) / 128);
      }
    }

    return input;
  }

  List<double> getEmbedding(img.Image faceImage) {
    final input = _preprocess(faceImage);

    final inputTensor = input.reshape([1, 112, 112, 3]);
    final output = List.filled(192, 0).reshape([1, 192]);

    _interpreter!.run(inputTensor, output);

    return List<double>.from(output[0]);
  }
}
