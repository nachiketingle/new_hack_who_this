import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';
import 'dart:convert';

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
    return SizeTransition(
      key: ValueKey<int>(index),
      sizeFactor: animation,
      child: ListTile(
        title: Text(_userList[index].name),
      ),
    );
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
        Navigator.of(context).pushNamed('/chooseWord', arguments: myWords);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pusher = PusherWeb();
  }

  void dispose() {
    for (String event in events) {
      pusher.unbindEvent(event);
    }
    pusher.unSubscribePusher(User.currUser.accessCode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      _loadUsers();
      _listenStream();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
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
            Text("Group Name: ${_user.groupName}"),
            Text("Access Code: ${_user.accessCode}"),
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
          ],
        ))
      ]),
      floatingActionButton: _user.isHost
          ? FloatingActionButton.extended(
              label: Text("Start"),
              onPressed: _startSketching,
            )
          : Container(),
    );
  }
}
