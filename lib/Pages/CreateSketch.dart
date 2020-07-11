import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/CustomWidgets/SketchCanvas.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';

class CreateSketch extends StatefulWidget {

  _CreateSketchState createState() => _CreateSketchState();
}

class _CreateSketchState extends State<CreateSketch> {

  GlobalKey<SketchCanvasState> _sketchCanvasKey = GlobalKey();

  Future<void> _submitSketch() async {
    String base64String = await _sketchCanvasKey.currentState.getImageData();
    
    Navigator.pushNamed(context, '/submitSketch', arguments: Sketch(base64String));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("CreateSketch"),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                right: 20,
                top: 20,
                child: Timer(
                  duration: Constants.sketchTimer,
                  callback: () {
                    _submitSketch();
                  },
                ),
              ),
              Positioned(
                top: 75,
                child: SketchCanvas(key: _sketchCanvasKey,),
              ),
              Positioned(
                bottom: 10,
                child: ColorPalette()
              )
            ],
          ),
        ),
      ),
    );
  }
}

