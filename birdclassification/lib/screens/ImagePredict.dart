import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class ImagePredict extends StatefulWidget {
  final File imageFile;
  const ImagePredict({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ImagePredict> createState() => _ImagePredictState();
}

class _ImagePredictState extends State<ImagePredict> {
  Future<List<dynamic>> imageClassification(File image) async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt");

    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (recognitions != null) {
      return recognitions;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.file(widget.imageFile),
            FutureBuilder(
                future: imageClassification(widget.imageFile),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data != null) {
                    print(snapshot.data.toString());
                    print("******");
                    return Container();
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
