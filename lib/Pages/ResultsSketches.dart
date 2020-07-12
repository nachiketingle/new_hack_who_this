import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Network/ResultsServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ResultsSketches extends StatefulWidget {
  _ResultsSketchesState createState() => _ResultsSketchesState();
}

class _ResultsSketchesState extends State<ResultsSketches> {
  bool _loaded = false;
  String word;
  String wordGuessed;

  Future<Map<String, Image>> _getAllSketches(String word) async {
    // assign the word getting details for
    Map<String, Image> details = new Map<String, Image>();
    // do api call to get details
    Map<String, dynamic> result =
        await ResultsServices.resultsDetails(User.currUser.accessCode, word);
    // get the list of details
    List<dynamic> sketchDetails = result["details"];
    print(result["guess"]);
    wordGuessed = result["guess"];
    for (Map<String, dynamic> sketchDetail in sketchDetails) {
      // map the drawer to the sketch image
      String drawer = sketchDetail["drawer"];
      String sketch = sketchDetail["sketch"];
      details[drawer] = Sketch(sketch).image;
    }
    print(details.keys);
    return details;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      word = ModalRoute.of(context).settings.arguments;
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
          Center(
            child: FutureBuilder(
              future: _getAllSketches(word),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, Image> map = snapshot.data;
                  List<String> names = map.keys.toList();
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .10),
                        Center(
                            child: Text(
                          "Sketches of " + word,
                          style: TextStyle(
                              fontSize: 25, color: Constants.textColor),
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                        Divider(),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: names.length,
                              itemBuilder: (context, index) {
                                print(index);
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Player " +
                                              names[index] +
                                              "'s drawing:",
                                          style: TextStyle(
                                              color: Constants.textColor,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01),
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: map[names[index]],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Divider(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                        Center(
                            child: Text(wordGuessed + " was guessed!",
                                style: TextStyle(
                                    fontSize: 25, color: Constants.textColor))),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                      ]);
                } else {
                  return Center(
                      child: Transform.scale(
                    child: SpinKitDoubleBounce(color: Constants.primaryColor),
                    scale: 2.5,
                  ));
                }
              },
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 24,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
