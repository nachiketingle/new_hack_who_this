import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Animations/Transitions.dart';
import 'package:new_hack_who_this/Network/ResultsServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Pages/ImportAllPages.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ResultsWords extends StatefulWidget {
  _ResultsWordsState createState() => _ResultsWordsState();
}

class _ResultsWordsState extends State<ResultsWords> {
  int numCorrect = 0;
  Map<String, bool> guesses = new Map<String, bool>();

  /// Get list of words from server
  Future<List<String>> _getWords() async {
    List<String> words = List();
    // count how many words were guessed correctly
    int correct = 0;
    Map<String, dynamic> results =
        await ResultsServices.results(User.currUser.accessCode);
    for (String word in results.keys) {
      guesses[word] = results[word];
      // get the list of words
      words.add(word);
      if (results[word] == true) {
        correct += 1;
      }
    }
    numCorrect = correct;
    return words;
  }

  /// Go to next page to view all sketches of the word
  void _viewWordSketches(String word) {
    //Navigator.pushNamed(context, '/resultsSketches', arguments: word);
    Navigator.push(context,
        CustomFadeTransition.createRoute(ResultsSketches(), args: word));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
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
            Center(
              child: FutureBuilder(
                  future: _getWords(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> words = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: Center(
                                    child: Text(
                                  "Your team guessed " +
                                      numCorrect.toString() +
                                      " words correctly!",
                                  style: TextStyle(
                                      fontSize: 25, color: Constants.textColor),
                                  textAlign: TextAlign.center,
                                ))),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: words.length,
                                itemBuilder: (context, index) {
                                  String word = words[index];
                                  return Card(
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: guesses[word]
                                                ? Colors.lightGreen
                                                : Colors.red),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Center(
                                          child: Text(
                                            word,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        _viewWordSketches(word);
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
                      return Center(
                          child: Transform.scale(
                        child:
                            SpinKitDoubleBounce(color: Constants.primaryColor),
                        scale: 2.5,
                      ));
                    }
                  }),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.home),
                iconSize: 24,
                onPressed: () {
                  Navigator.pushReplacement(
                      context, CustomFadeTransition.createRoute(Home()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
