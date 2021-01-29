import 'package:camera/camera.dart';
import 'package:cyborg/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CyborgScreen extends StatefulWidget {
  @override
  _CyborgScreenState createState() => _CyborgScreenState();
}

class _CyborgScreenState extends State<CyborgScreen> {

  bool isWorking = false;
  String results = "";
  CameraController cameraController;
  CameraImage cameraImage;

  loadModel() async {
    await Tflite.loadModel(
        model: 'mobilenet_v1_1.0_224.tflite',
        labels: 'mobilenet_v1_1.0_224.txt'
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      
      setState(()  {
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
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async{
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {
                      setState(() {
                        initCamera();
                      });
                    }
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        cameraImage = null;
                        isWorking = false;
                      });
                    })
              ],
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Center(
                    child: Container(
                      color: Colors.blue,
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child: cameraImage == null ? SizedBox(
                      ) :
                      AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio ?? 16.0/9.0,
                        child: CameraPreview(cameraController),
                      ),
                    )
                ),
                Container(
                  color: Colors.pink,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
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
      ),
    );
  }
}
