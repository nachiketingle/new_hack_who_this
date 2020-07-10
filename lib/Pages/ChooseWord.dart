import 'package:flutter/material.dart';
import 'package:new_hack_who_this/CustomWidgets/Timer.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';

class ChooseWord extends StatefulWidget {

  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {

  Future<List<String>> _getName() async {
      List<String> words = List();
      words.add('Banana');
      words.add('Apple');
      words.add('Orange');
      return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChooseWord"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.pushNamed(context, '/previousSketch');
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: _getName(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<String> words = snapshot.data;
              return Stack(
                children: <Widget>[
                  Positioned(
                    right: 20,
                    top: 10,
                    child: Timer(
                      duration: Constants.chooseWordTimer,
                      callback: () {
                        Navigator.pushNamed(context, '/previousSketch');
                      },
                    ),
                  ),
                ],
              );
            }
            else {
              return CircularProgressIndicator();
            }
          },
        )
      ),
    );
  }
}