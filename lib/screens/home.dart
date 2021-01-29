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
        body: Container(
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height/3,
                child: Center(
                  child: FlatButton(
                    child: cameraImage == null ? Text(
                      'Press'
                    ) :
                    AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    ),
                    onPressed: () {
                      initCamera();
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.pink,
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: FlatButton(
                    child: Text(
                        ''
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
