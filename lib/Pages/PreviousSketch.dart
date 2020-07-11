import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';

class PreviousSketch extends StatefulWidget {

  _PreviousSketchState createState() => _PreviousSketchState();
}

class _PreviousSketchState extends State<PreviousSketch> {
  bool _loaded;
  int _roundNumber;
  bool _isGuessing;
  Map<dynamic, dynamic> playerToWord;
  static final base64String  = "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";

  Future<List<int>> _getImageBytes() async {
    // Group Services
    await Future.delayed(Duration(seconds: 3)); // Used to simulate network delay
    return base64Decode(base64String);
  }

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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.of(context).pushNamed('/createSketch');
              },
            )
          ],
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: FutureBuilder(
              future: _getImageBytes(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<int> bytes = snapshot.data;
                  return Stack(
                      children: <Widget>[
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Timer(
                            duration: Constants.viewSketchTimer,
                            callback: () {
                              Navigator.of(context).pushNamed('/createSketch');
                            },
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Remember this image!", style: TextStyle(fontSize: 20),),
                              Image.memory(bytes, fit: BoxFit.cover,),
                            ],
                          ),
                        ),
                      ]
                  );
                }
                else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
        ),
      ),
    );
  }
}