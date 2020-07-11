import 'package:flutter/material.dart';

class PreviousSketch extends StatefulWidget {

  _PreviousSketchState createState() => _PreviousSketchState();
}

class _PreviousSketchState extends State<PreviousSketch> {
  bool _loaded;
  int _roundNumber;
  bool _isGuessing;
  Map<dynamic, dynamic> playerToWord;

  @override
  Widget build(BuildContext context) {
    if(!_loaded) {
      _loaded = true;
      Map<String, dynamic> roundInfo = ModalRoute.of(context).settings.arguments;
      print(roundInfo);
    }

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