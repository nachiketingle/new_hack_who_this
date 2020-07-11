import 'package:flutter/material.dart';

class ResultsSketches extends StatefulWidget {

  _ResultsSketchesState createState() => _ResultsSketchesState();
}

class _ResultsSketchesState extends State<ResultsSketches> {

  bool _loaded = false;
  String word;
  String wordGuessed;

  Future<Map<String, Image>> _getAllSketches(String word) async{

    wordGuessed = "Absolutely Nothing";

    await Future.delayed(Duration(seconds: 3));

    return Map();
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