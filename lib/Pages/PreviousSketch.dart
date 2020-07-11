import 'package:flutter/material.dart';

class PreviousSketch extends StatefulWidget {

  _PreviousSketchState createState() => _PreviousSketchState();
}

class _PreviousSketchState extends State<PreviousSketch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("PreviousSketch"),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("Create Sketch"),
            onPressed: () {
              Navigator.of(context).pushNamed('/createSketch');
            },
          ),
        ),
      ),
    );
  }
}