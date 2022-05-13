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
  late List _results;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res = (await Tflite.loadModel(
        model: "assets/model/birdclass.tflite",
        labels: "assets/model/labels.txt"))!;
  }

  Future<List<dynamic>> imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(widget.imageFile),
          ),
          FutureBuilder(
              future: imageClassification(widget.imageFile),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return CircularProgressIndicator();
                } else if (snapshot.data != null) {
                  for (var item in snapshot.data as List) {
                    print(item + "*****");
                  }
                  return Container();
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}
