import 'package:camera/camera.dart';
import 'package:cyborg/main.dart';
import 'package:flutter/material.dart';

class CyborgScreen extends StatefulWidget {
  @override
  _CyborgScreenState createState() => _CyborgScreenState();
}

class _CyborgScreenState extends State<CyborgScreen> {

  bool isWorking = false;
  String results = "";
  CameraController cameraController;
  CameraImage cameraImage;

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      
      setState(() {
        cameraController.startImageStream((image) => {
          if(!isWorking){
            isWorking = true,
            cameraImage = image,
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
