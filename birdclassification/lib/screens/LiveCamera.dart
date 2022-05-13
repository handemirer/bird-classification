import 'package:birdclassification/bndbox.dart';
import 'package:birdclassification/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class LiveCamera extends StatefulWidget {
  const LiveCamera({Key? key}) : super(key: key);

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  // late List<CameraDescription> cameras;
  List<dynamic> _recognitions = [];

  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt");
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  Future<List<CameraDescription>> getCameras() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras;
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getCameras(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Container(
                  child: Stack(
                    children: [
                      Camera(
                        snapshot.data as List<CameraDescription>,
                        _model,
                        setRecognitions,
                      ),
                      BndBox(
                        _recognitions,
                        math.max(_imageHeight, _imageWidth),
                        math.min(_imageHeight, _imageWidth),
                        screen.height,
                        screen.width,
                        _model,
                      ),
                    ],
                  ),
                );
              } else {
                return LinearProgressIndicator();
              }
            }),
      ),
    );
  }
}
