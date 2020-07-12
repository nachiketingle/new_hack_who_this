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
          body: Stack(children: <Widget>[
        Opacity(
            opacity: .6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      Constants.primaryColor,
                      Constants.secondaryColor
                    ]),
              ),
            )),
        Container(
            child: Column(children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .05),
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
                            Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: 20.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "Remember this image! You'll need to "),
                                      TextSpan(
                                          text: _isGuessing
                                              ? "guess"
                                              : "draw",
                                          style: TextStyle(
                                              color:
                                                  Constants.primaryColor)),
                                      TextSpan(text: " it!"),
                                    ],
                                    style: TextStyle(
                                        color: Constants.textColor,
                                        fontSize: 20,
                                        fontFamily: "Montserrat"),
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    .05),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.6,
                              height:
                                  MediaQuery.of(context).size.height * 0.6,
                              child:
                                  Image.memory(bytes, fit: BoxFit.contain),
                              decoration:
                                  BoxDecoration(color: Colors.white),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .1),
                      Text(
                        "You chose to draw: ",
                        style: TextStyle(
                            fontSize: 30, color: Constants.textColor),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .05),
                      Text(_myWord,
                          style: TextStyle(
                              fontSize: 50,
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .05),
                      Text("Good Luck!",
                          style: TextStyle(
                              fontSize: 30, color: Constants.textColor)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .25),
                    ],
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .05),
          Timer(
            duration: Constants.viewSketchTimer,
            callback: () {
              if (_isGuessing) {
                Navigator.of(context)
                    .pushReplacement(CustomFadeTransition.createRoute(GuessWord()));
              } else {
                Navigator.of(context)
                    .pushReplacement(CustomFadeTransition.createRoute(CreateSketch()));
              }
            },
          ),
        ])),
      ])),
    );
  }
}
