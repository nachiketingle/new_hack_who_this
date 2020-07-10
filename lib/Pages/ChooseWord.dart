import 'package:flutter/material.dart';

class ChooseWord extends StatefulWidget {

  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {

  void _getName() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChooseWord"),
      ),
      body: Center(
        child: FutureBuilder(

        )
      ),
    );
  }
}