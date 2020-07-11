import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/CustomWidgets/SketchCanvas.dart';

class CreateSketch extends StatefulWidget {

  _CreateSketchState createState() => _CreateSketchState();
}

class _CreateSketchState extends State<CreateSketch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("CreateSketch"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {

                });
              },
            )
          ],
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

                  },
                ),
              ),
              Positioned(
                top: 75,
                child: SketchCanvas(),
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

