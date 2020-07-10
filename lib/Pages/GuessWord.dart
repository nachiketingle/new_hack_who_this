import 'package:flutter/material.dart';

class GuessWord extends StatefulWidget {

  _GuessWordState createState() => _GuessWordState();
}

class _GuessWordState extends State<GuessWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GuessWord"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Results Words"),
        ),
      ),
    );
  }
}