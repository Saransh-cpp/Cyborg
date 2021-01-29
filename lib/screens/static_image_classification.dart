
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class ImageClassification extends StatefulWidget {
  @override
  _ImageClassificationState createState() => _ImageClassificationState();
}

class _ImageClassificationState extends State<ImageClassification> {
  String _model = yolo;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/ssd_mobilenet.tflite",
          labels: "assets/ssd_mobilenet.txt",
        );
      }
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  pickImage() async {
    File image = File(await ImagePicker().getImage(source: ImageSource.gallery).then((value) => value.path));
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(File image) async {
    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.red;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: blue,
                width: 3,
              )),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: _image == null ? MediaQuery.of(context).size.height/3 : MediaQuery.of(context).size.height/12,
      left: 0.0,
      width: size.width,
      child: _image == null ? Center(child: Text("Please Select an Image", style: TextStyle(color: Colors.deepPurple, fontSize: 30),)) : Image.file(_image),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Object Detection"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.image),
          backgroundColor: Colors.deepPurple,
          onPressed: pickImage,
        ),
        body: Center(
          child: Container(
            child: Center(
              child: Stack(
                children: stackChildren,
              ),
            ),
          ),
        ),
      ),
    );
  }
}