import 'package:flutter/material.dart';

class ChooseWord extends StatefulWidget {

  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChooseWord"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("View Previous Sketch"),
        ),
      ),
    );
  }
}