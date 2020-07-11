import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Animations/Transitions.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
import 'package:new_hack_who_this/Pages/ImportAllPages.dart';

class SubmitSketch extends StatefulWidget {
  _SubmitSketchState createState() => _SubmitSketchState();
}

class _SubmitSketchState extends State<SubmitSketch> {
  Sketch _sketch;
  bool _loaded = false;
  bool _roundStarted = false;
  PusherWeb pusher;

  // listen for events
  void _listenStream() async {
    // initialize pusher
    List<String> events = ["onRoundStart"];
    await pusher.firePusher(User.currUser.accessCode, events);
    // add listener for events
    pusher.eventStream.listen((event) async {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      // round start event
      if (json['event'] == "onRoundStart" && !_roundStarted) {
        _roundStarted = true;
        // wait a little to see own drawing
        await Future.delayed(Duration(seconds: 3));
        //Navigator.pushNamed(context, '/previousSketch', arguments: json['message']);
        Navigator.push(context, CustomFadeTransition.createRoute(PreviousSketch(), args: json['message']));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pusher = PusherWeb();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      _sketch = ModalRoute.of(context).settings.arguments;
      _listenStream();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("SubmitSketch"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              //Navigator.of(context).pushNamed('/guessWord');
              Navigator.push(context, CustomFadeTransition.createRoute(GuessWord()));
            },
          )
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "TIME UP!\nThis is what you drew.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              _sketch.image,
              Text(
                "Waiting for next",
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
    );
  }
}
