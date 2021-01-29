import 'package:cyborg/screens/static_image_classification.dart';
import 'package:cyborg/screens/two_objects_realtime_identification.dart';
import 'package:flutter/material.dart';

class Choice extends StatefulWidget {
  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => Identifying2Objects()));
                  },
                  child: Text('Real time Image Object detection')
              ),
              FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => ImageClassification()));
                  },
                  child: Text('Image Detection')
              ),
              FlatButton(
                  color: Colors.white,
                  onPressed: () {},
                  child: Text('Cat or Dog classifier')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
