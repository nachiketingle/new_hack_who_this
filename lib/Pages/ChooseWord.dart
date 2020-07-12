import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/Network/SketchServices.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
import 'package:new_hack_who_this/Pages/ImportAllPages.dart';
import '../Animations/Transitions.dart';
import 'dart:convert';

class ChooseWord extends StatefulWidget {
  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {
  /// Selected word
  String _selected;
  List<String> _words;
  bool _loaded = false;
  bool _roundStarted = false;
  PusherWeb pusher;
  List<String> events = ["onRoundStart"];

  void _submitWord() async {
    SketchServices.submitWord(
        User.currUser.accessCode, User.currUser.name, _selected);
  }

  // listen for events
  void _listenStream() async {
    // initialize pusher
    await pusher.firePusher(User.currUser.accessCode, events);
    // add listener for events
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      // when all users chose word
      if (json['event'] == "onRoundStart" && !_roundStarted) {
        _roundStarted = true;
        //Navigator.pushNamed(context, '/previousSketch', arguments: json['message']);
        Navigator.pushReplacement(
            context,
            CustomFadeTransition.createRoute(PreviousSketch(),
                args: json['message']));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pusher = PusherWeb();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      _words = ModalRoute.of(context).settings.arguments;
      _selected = _words.first;
      _listenStream();
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
                    colors: [Constants.primaryColor, Constants.secondaryColor]),
              ),
            )),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .05),
              Text(
                "Choose a word to draw!",
                style: TextStyle(color: Constants.textColor, fontSize: 23),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .05),
              // Display list of selectable words
              _WordList(
                  words: _words,
                  selected: (selectedWord) {
                    _selected = selectedWord;
                  }),
              SizedBox(height: MediaQuery.of(context).size.height * .05),
              // Display custom timer
              Timer(
                duration: Constants.chooseWordTimer,
                callback: () {
                  _submitWord();
                },
              ),
            ],
          ),
        )),
      ])),
    );
  }
}

/// List of selectable words
class _WordList extends StatefulWidget {
  _WordList({Key key, @required this.words, @required this.selected})
      : super(key: key);

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
            child: Text(
              word,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
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
