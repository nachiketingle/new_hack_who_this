import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/SketchServices.dart';
import 'package:new_hack_who_this/Pages/CreateSketch.dart';
import 'package:new_hack_who_this/Pages/GuessWord.dart';
import '../Animations/Transitions.dart';

class PreviousSketch extends StatefulWidget {
  _PreviousSketchState createState() => _PreviousSketchState();
}

class _PreviousSketchState extends State<PreviousSketch> {
  bool _loaded = false;
  int _roundNumber;
  bool _isGuessing;
  String _myWord;

  Future<List<int>> _getImageBytes() async {
    String base64String =
        await SketchServices.latestSketch(User.currUser.accessCode, _myWord);
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      // get the round info
      Map<String, dynamic> roundInfo =
          ModalRoute.of(context).settings.arguments;
      _roundNumber = roundInfo["roundNumber"];
      _isGuessing = roundInfo["isGuessing"];
      Map<String, dynamic> playerToWord = roundInfo["playerToWord"];
      // find the word assigned to current user
      for (String player in playerToWord.keys) {
        if (player == User.currUser.name) {
          _myWord = playerToWord[player];
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("PreviousSketch"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                //Navigator.of(context).pushNamed('/createSketch');
                Navigator.of(context).push(CustomFadeTransition.createRoute(CreateSketch()));
              },
            )
          ],
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Positioned(
                top: 20,
                right: 20,
                child: Timer(
                  duration: Constants.viewSketchTimer,
                  callback: () {
                    if (_isGuessing) {
                      //Navigator.of(context).pushNamed('/guessWord');
                      Navigator.of(context).push(CustomFadeTransition.createRoute(GuessWord()));
                    } else {
                      //Navigator.of(context).pushNamed('/createSketch');
                      Navigator.of(context).push(CustomFadeTransition.createRoute(CreateSketch()));
                    }
                  },
                ),
              ),
              Center(
                child: _roundNumber > 0
                    ? FutureBuilder(
                        future: _getImageBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<int> bytes = snapshot.data;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Remember this image! You'll need to " +
                                      (_isGuessing ? "guess" : "draw") +
                                      " it!",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.75,
                                  child: Image.memory(
                                    bytes,
                                    fit: BoxFit.contain
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    : Text("You chose to draw " + _myWord + "! Good Luck!"),
              ),
            ])),
      ),
    );
  }
}
