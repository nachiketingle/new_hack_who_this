import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';

class SubmitSketch extends StatefulWidget {

  _SubmitSketchState createState() => _SubmitSketchState();
}

class _SubmitSketchState extends State<SubmitSketch> {

  Sketch _sketch;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    if(!_loaded) {
      _loaded = true;
      _sketch = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("SubmitSketch"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.of(context).pushNamed('/guessWord');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("TIME UP!\nThis is what you drew.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            _sketch.image,
            Text("Waiting for next", style: TextStyle(color: Colors.grey),)
          ],
        )
      ),
    );
  }
}