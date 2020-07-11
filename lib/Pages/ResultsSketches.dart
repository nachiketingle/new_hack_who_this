import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Network/ResultsServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Models/Sketch.dart';

class ResultsSketches extends StatefulWidget {

  _ResultsSketchesState createState() => _ResultsSketchesState();
}

class _ResultsSketchesState extends State<ResultsSketches> {

  bool _loaded = false;
  String word;
  String wordGuessed;

  Future<Map<String, Image>> _getAllSketches(String word) async{
    // assign the word getting details for
    wordGuessed = word;
    Map<String, Image> details = new Map<String,Image>();
    // do api call to get details
    Map<String, dynamic> result =
        await ResultsServices.resultsDetails(User.currUser.accessCode, word);
    // get the list of details
    List<dynamic> sketchDetails = result["details"];
    for(Map<String, dynamic> sketchDetail in sketchDetails) {
      // map the drawer to the sketch image
      String drawer = sketchDetail["drawer"];
      String sketch = sketchDetail["sketch"];
      details[drawer] = Sketch(sketch).image;
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    if(!_loaded) {
      _loaded = true;
      word = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ResultsSketches"),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getAllSketches(word),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              Map<String, Image> map = snapshot.data;
              List<String> names = map.keys.toList();

              return ListView.builder(
                  itemCount: names.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Text("Word Chosen: " + word);
                    }
                    else if (index == names.length + 1) {
                      return Text("Word Guessed: " + wordGuessed);
                    }
                    else {
                      return Card(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(names[index - 1]),
                              map[names[index - 1]]
                            ],
                          ),
                        ),
                      );
                    }
                  }
              );

            }
            else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}