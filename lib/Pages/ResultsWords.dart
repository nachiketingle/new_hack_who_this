import 'package:flutter/material.dart';

class ResultsWords extends StatefulWidget {

  _ResultsWordsState createState() => _ResultsWordsState();
}

class _ResultsWordsState extends State<ResultsWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ResultsWords"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Results - Sketches"),
        ),
      ),
    );
  }
}