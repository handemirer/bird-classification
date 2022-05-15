import 'dart:io';
import 'package:birdclassification/screens/ImagePredict.dart';
import 'package:birdclassification/screens/LiveCamera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var box = Hive.box("predictions");

  @override
  Widget build(BuildContext context) {
    List<String> predictionList = getPredictions();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getBottomSheet,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/kus.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white24,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        Text(
                          " Eski Tahmin Sonuçları",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: predictionList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.white24,
                          child: Text(
                            predictionList[index],
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  List<String> getPredictions() {
    List<String> tempList = [];
    for (var element in box.values) {
      tempList.add(element);
    }
    return tempList;
  }

  void getBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.45,
            builder: (context, scrollController) {
              return Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 11),
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Kuş Türü Bul",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  ))
                                  .then((value) => setState(
                                        () {},
                                      ));
                            }
                          }),
                          elevation: 0,
                          label: Text("Galeriden Seç"),
                          icon: Icon(Icons.image),
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
                                  ))
                                  .then((value) => setState(
                                        () {},
                                      ));
                            }
                          }),
                          elevation: 0,
                          label: Text("Fotoğraf Çek"),
                          icon: Icon(Icons.camera_alt_rounded),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton.extended(
                      onPressed: (() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LiveCamera(),
                          ),
                        );
                      }),
                      elevation: 0,
                      label: Text("Canlı Kuş Bul"),
                      icon: Icon(Icons.cast),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
