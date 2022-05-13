import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:birdclassification/colors.dart';
import 'package:birdclassification/media.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
      ),
      body: const Center(
        child: Text("Gallery"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMediaInputs(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showMediaInputs(BuildContext context) async {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const Text('Seçim Yapın'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FloatingActionButton(
                            backgroundColor: primaryColor,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              //String? content = await Media().openCamera();
                              XFile? _tempImage = await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                  maxHeight: 224,
                                  maxWidth: 224,
                                  imageQuality: 100);
                              if (_tempImage == null) {
                              } else {}
                              if (_tempImage == null) {
                              } else {
                                await Tflite.loadModel(
                                    model: "assets/mobilenet_v1_1.0_224.tflite",
                                    labels: "assets/mobilenet_v1_1.0_224.txt");

                                await Tflite.runModelOnImage(
                                  path: _tempImage!.path,
                                  numResults: 2,
                                  threshold: 0.05,
                                  imageMean: 127.5,
                                  imageStd: 127.5,
                                ).then((recognitions) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(recognitions![0]["label"]
                                                  .toString()),
                                              Text(recognitions[1]["label"]
                                                  .toString()),
                                            ],
                                          ),
                                        );
                                      });
                                  print("Detection took ${recognitions}");
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Fotoğraf Çek'),
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.amber,
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              //String? content = await Media().openGallery();

                              XFile? _tempImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                maxHeight: 224,
                                maxWidth: 224,
                                imageQuality: 100,
                              );

                              await Tflite.loadModel(
                                  model: "assets/mobilenet_v1_1.0_224.tflite",
                                  labels: "assets/mobilenet_v1_1.0_224.txt");

                              await Tflite.runModelOnImage(
                                path: _tempImage!.path,
                                numResults: 6,
                                threshold: 0.05,
                                imageMean: 127.5,
                                imageStd: 127.5,
                              ).then((recognitions) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(recognitions![0]["label"]
                                                .toString()),
                                          ],
                                        ),
                                      );
                                    });
                                print("Detection took ${recognitions}");
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Fotoğraf Seç')
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.red,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Kapat'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
