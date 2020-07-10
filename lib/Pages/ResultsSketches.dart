import 'package:flutter/material.dart';

class ResultsSketches extends StatefulWidget {

  _ResultsSketchesState createState() => _ResultsSketchesState();
}

class _ResultsSketchesState extends State<ResultsSketches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ResultsSketches"),
      ),
      body: Center(
        child: Text("Join Group"),
      ),
    );
  }
}