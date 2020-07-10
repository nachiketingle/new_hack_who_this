import 'package:flutter/material.dart';

class CreateSketch extends StatefulWidget {

  _CreateSketchState createState() => _CreateSketchState();
}

class _CreateSketchState extends State<CreateSketch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CreateSketch"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Submit Sketch"),
        ),
      ),
    );
  }
}