import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Animations/Transitions.dart';
import 'package:new_hack_who_this/Network/SketchServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
import 'dart:convert';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:new_hack_who_this/Pages/ImportAllPages.dart';

class GuessWord extends StatefulWidget {
  _GuessWordState createState() => _GuessWordState();
}

class _GuessWordState extends State<GuessWord> {
  PusherWeb pusher;
  bool guessed = false;

  /// Get list of words from server
  Future<List<String>> _getWords() async {
    List<String> words = List();
    List<dynamic> results = await SketchServices.promptGuess(
        User.currUser.accessCode, User.currUser.name);
    for (String word in results) {
      words.add(word);
    }
    return words;
  }

  /// Submit guessed word
  void _guessedWord(String word) {
    // Tell server
    SketchServices.submitGuess(
        User.currUser.accessCode, word, User.currUser.name);
    setState(() {
      guessed = true;
    });
  }

  // listen for events
  void _listenStream() async {
    // initialize pusher
    List<String> events = ["onGameEnd"];
    await pusher.firePusher(User.currUser.accessCode, events);
    // add listener for events
    pusher.eventStream.listen((event) async {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      // game end event
      if (json['event'] == "onGameEnd") {
        //Navigator.of(context).pushNamed('/resultsWords');
        Navigator.pushReplacement(
            context, CustomFadeTransition.createRoute(ResultsWords()));
      }
    });
  }

  @override
  void initState() {
    pusher = PusherWeb();
    _listenStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    colors: [Constants.primaryColor, Constants.secondaryColor]),
              ),
            )),
        Center(
          child: !guessed
              ? FutureBuilder(
                  future: _getWords(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> words = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: Center(
                                    child: Text(
                                  "What is this a picture of?",
                                  style: TextStyle(
                                      fontSize: 20, color: Constants.textColor),
                                ))),
                            Expanded(
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: words.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: InkWell(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Center(
                                          child: Text(
                                            words[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        _guessedWord(words[index]);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Waiting on others...",
                      style:
                          TextStyle(color: Constants.textColor, fontSize: 30),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                    Transform.scale(
                      child: SpinKitDoubleBounce(color: Constants.primaryColor),
                      scale: 4,
                    )
                  ],
                ),
        ),
      ])),
    );
  }
}
