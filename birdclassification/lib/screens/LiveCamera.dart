import 'package:birdclassification/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class LiveCamera extends StatefulWidget {
  const LiveCamera({Key? key}) : super(key: key);

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  List<dynamic> _recognitions = [];

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt");
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void initState() {
    super.initState();
    getCameras();
    loadModel();
  }

  Future<List<CameraDescription>> getCameras() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras;
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Kamerayı Kuşa Çevirin"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getCameras(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Column(
                  children: [
                    Container(
                      color: Colors.pink,
                      height: screen.width,
                      width: screen.width,
                      child: ClipRRect(
                        child: Camera(
                          cameras: snapshot.data as List<CameraDescription>,
                          setRecognitions: setRecognitions,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        shrinkWrap: true,
                        itemCount: _recognitions.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_recognitions[index]["label"]}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${(_recognitions[index]["confidence"] * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const LinearProgressIndicator();
              }
            }),
      ),
    );
  }
}
