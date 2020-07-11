import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Animations/Transitions.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/CustomWidgets/SketchCanvas.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';
import 'package:new_hack_who_this/Network/SketchServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Pages/ImportAllPages.dart';

class CreateSketch extends StatefulWidget {

  _CreateSketchState createState() => _CreateSketchState();
}

class _CreateSketchState extends State<CreateSketch> {

  GlobalKey<SketchCanvasState> _sketchCanvasKey = GlobalKey();

  Future<void> _submitSketch() async {
    // get encoded string for sketch
    String base64String = await _sketchCanvasKey.currentState.getImageData();
    // submit the sketch to the server
    SketchServices.submitSketch(User.currUser.accessCode, base64String, User.currUser.name);
    // view sketch
    //Navigator.pushNamed(context, '/submitSketch', arguments: Sketch(base64String));
    Navigator.pushReplacement(context, CustomFadeTransition.createRoute(SubmitSketch(), args: Sketch(base64String)));
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
                child: ColorPalette(
                    undo: () {
                      _sketchCanvasKey.currentState.undoLine();
                    },
                  clear: () {
                      _sketchCanvasKey.currentState.clearCanvas();
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

