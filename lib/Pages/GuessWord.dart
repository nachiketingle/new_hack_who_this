import 'package:flutter/material.dart';

class GuessWord extends StatefulWidget {

  _GuessWordState createState() => _GuessWordState();
}

class _GuessWordState extends State<GuessWord> {

  /// Get list of words from server
  Future<List<String>> _getWords() async {
    List<String> words = List();
    words.add("Apple");
    words.add("Banana");
    words.add("Cucumber");

    await Future.delayed(Duration(seconds: 3));
    return words;
  }

  /// Submit guessed word
  void _guessedWord(String word) {
    // Tell server

    Navigator.pushNamed(context, '/resultsWords');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GuessWord"),
      ),
      body: Center(
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
                            child: Text("What is this a picture of?", style: TextStyle(fontSize: 20),)
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