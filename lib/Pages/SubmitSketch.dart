import 'package:flutter/material.dart';

class SubmitSketch extends StatefulWidget {

  _SubmitSketchState createState() => _SubmitSketchState();
}

class _SubmitSketchState extends State<SubmitSketch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SubmitSketch"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Guess Word"),
        ),
      ),
    );
  }
}