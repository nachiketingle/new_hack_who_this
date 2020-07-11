import 'package:flutter/material.dart';

class ResultsWords extends StatefulWidget {

  _ResultsWordsState createState() => _ResultsWordsState();
}

class _ResultsWordsState extends State<ResultsWords> {

  int numCorrect = 0;

  /// Get list of words from server
  Future<List<String>> _getWords() async {
    List<String> words = List();
    words.add("Apple");
    words.add("Banana");
    words.add("Cucumber");

    await Future.delayed(Duration(seconds: 3));
    numCorrect = 2;
    return words;
  }

  /// Go to next page to view all sketches of the word
  void _viewWordSketches(String word) {

    Navigator.pushNamed(context, '/resultsSketches', arguments: word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ResultsWords"),
      ),
      body:Center(
        child: FutureBuilder(
            future: _getWords(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<String> words = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Center(
                              child: Text("# CORRECT: " + numCorrect.toString(), style: TextStyle(fontSize: 20),)
                          )
                      ),

                      Expanded(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: words.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: InkWell(
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  child: Center(
                                    child: Text(words[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  ),
                                ),
                                onTap: () {
                                  _viewWordSketches(words[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }
        ),
      ),
    );
  }
}