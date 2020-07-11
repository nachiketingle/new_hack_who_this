import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';

class ChooseWord extends StatefulWidget {

  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {

  /// Selected word
  String _selected;

  /// Get all the words from server and return list
  Future<List<String>> _getWords() async {
    List<String> words = List();
    words.add('Banana');
    words.add('Apple');
    words.add('Orange');
    _selected = words.first;
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ChooseWord"),
          actions: <Widget>[
            // Temp button for testing
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                if(mounted) {
                  Navigator.pushNamed(context, '/previousSketch');
                }
              },
            )
          ],
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
                        // Display custom timer
                        Timer(
                          duration: Constants.chooseWordTimer,
                          callback: () {
                            Navigator.pushNamed(context, '/previousSketch');
                          },
                        ),
                        
                        // Display list of selectable words
                        _WordList(words: words, selected: (selectedWord) {
                          _selected = selectedWord;
                        }),
                      ],
                    ),
                  );
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            )
        ),
      ),
    );
  }
}

/// List of selectable words
class _WordList extends StatefulWidget {
  _WordList({Key key, @required this.words, @required this.selected}) :
        super(key: key);

  _WordListState createState() => _WordListState();

  final List<String> words;
  final Function(String) selected;
}

class _WordListState extends State<_WordList> {

  String _selected;

  Widget _wordBuilder(String word) {
    return GestureDetector(
      onTap: () {
        _updateSelected(word);
      },
      child: Card(
        color: word.compareTo(_selected) == 0 ? Colors.green : Colors.red,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Center(
            child: Text(word, style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }

  /// Notifies parent that new words has been selected
  void _updateSelected(String word) {
    setState(() {
      _selected = word;
      widget.selected.call(word);
    });
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.words.first;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.words.length,
      itemBuilder: (context, index) {
        return _wordBuilder(widget.words[index]);
      },
    );
  }
}