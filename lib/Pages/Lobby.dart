import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Animations/Transitions.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';
import 'dart:convert';

import 'package:new_hack_who_this/Pages/ChooseWord.dart';

class Lobby extends StatefulWidget {
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  User _user;
  bool _loaded = false;
  List<User> _userList = List();
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  PusherWeb pusher;
  List<String> events = ["onGuestJoin", "onGameStart"];

  List<String> emojis = [
    '🍇',
    '🍈',
    '🍉',
    '🍊',
    '🍋',
    '🍌',
    '🍍',
    '🍎',
    '🍏',
    '🍐',
    '🍑',
    '🍒',
    '🍓',
    '🥝',
    '🍅',
    '🥑'
  ];

  void _startSketching() {
    GroupServices.startGame(_user.accessCode);
  }

  void _loadUsers() async {
    // get all users from previous page
    _userList = ModalRoute.of(context).settings.arguments;
    // assign current user
    _user = User.currUser;
  }

  Widget _userBuilder(
      User user, int index, BuildContext context, Animation<double> animation) {
    Animation<Offset> offset;
    offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: animation,
      curve: Curves.ease,
    ));

    return SlideTransition(
        key: ValueKey<int>(index),
        position: offset,
        child: Column(children: <Widget>[
          ListTile(
            dense: true,
            leading: Text('${emojis[index % emojis.length]}',
                style: TextStyle(fontSize: 30)),
            title: Text(
              _userList[index].name,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(index == 0 ? "Owner" : 'Guest #$index'),
          ),
          Divider()
        ]));
  }

  // listen for events
  void _listenStream() async {
    // initialize pusher
    await pusher.firePusher(_user.accessCode, events);
    // add listener for events
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      // guest join event
      if (json['event'] == "onGuestJoin") {
        setState(() {
          // get new list
          List<dynamic> _temp = json['message'];
          int startFill = _userList.length;
          // add every new name
          for (; startFill < _temp.length; startFill++) {
            _userList.add(User.min(name: _temp[startFill]));
            _animatedListKey.currentState.insertItem(_userList.length - 1,
                duration: Duration(milliseconds: 500));
          }
        });
      } else if (json['event'] == "onGameStart") {
        Map<String, dynamic> wordChoices = json['message'];
        List<String> myWords = [];
        for (String player in wordChoices.keys) {
          if (player == User.currUser.name) {
            for (String word in wordChoices[player]) {
              myWords.add(word);
            }
          }
        }
        print("Starting Game with words " + myWords.toString());
        //Navigator.of(context).pushNamed('/chooseWord', arguments: myWords);
        Navigator.pushReplacement(context, CustomFadeTransition.createRoute(ChooseWord(), args: myWords));
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
      _loadUsers();
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
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text(
                    _user.groupName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Constants.primaryColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Access Code: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      SelectableText(
                        _user.accessCode.toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: AnimatedList(
                      key: _animatedListKey,
                      shrinkWrap: true,
                      initialItemCount: _userList.length,
                      itemBuilder: (context, index, animation) {
                        return _userBuilder(
                            _userList[index], index, context, animation);
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding:
                        EdgeInsets.all(MediaQuery.of(context).size.height * .03),
                        child: Text(
                          "Group Size: " + _userList.length.toString(),
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              )
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
        floatingActionButton: _user.isHost
            ? FloatingActionButton.extended(
          label: Text("Start"),
          onPressed: _startSketching,
        )
            : Container(),
      ),
    );
  }
}
