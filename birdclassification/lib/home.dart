import 'dart:ffi';
import 'dart:io';

import 'package:birdclassification/bc_navigator_push.dart';
import 'package:birdclassification/gallery.dart';
import 'package:birdclassification/homepage.dart';
import 'package:birdclassification/screens/ImagePredict.dart';
import 'package:birdclassification/screens/LiveCamera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Bird Classification"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getBottomSheet,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/bird.jpeg"),
            ),
            ElevatedButton(
                child: const Text("LİVE"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LiveCamera(),
                    ),
                  );
                }),
            ElevatedButton(
              child: const Text("Gallery"),
              onPressed: () {
                //showMediaInputs();
                //bcNavigatorPush(context: context, page: const Gallery());
              },
            ),
            ElevatedButton(
              child: const Text("Gallery"),
              onPressed: () =>
                  bcNavigatorPush(context: context, page: HomePage2()),
            ),
          ],
        ),
      ),
    );
  }

  void getBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: (() async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          //imageFile = File(image.path);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => ImagePredict(
                              imageFile: File(image.path),
                            ),
                          ));
                        }
                      }),
                      elevation: 0,
                      label: Text("Galeriden Seç"),
                      icon: Icon(Icons.camera_alt_rounded),
                    ),
                    FloatingActionButton.extended(
                      onPressed: (() async {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          //imageFile = File(image.path);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => ImagePredict(
                              imageFile: File(image.path),
                            ),
                          ));
                        }
                      }),
                      elevation: 0,
                      label: Text("Fotoğraf Çek"),
                      icon: Icon(Icons.camera_alt_rounded),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
