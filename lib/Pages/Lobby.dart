import 'package:flutter/material.dart';
import 'dart:async';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/PusherWeb.dart';
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

  void _startSketching() {
    Navigator.of(context).pushNamed('/chooseWord');
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
    List<String> events = ["onGuestJoin", "onGameStart"];
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
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pusher = PusherWeb();
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
      body: Center(
          child: Column(
        children: <Widget>[
          Text("Group Name: ${_user.groupName}"),
          Text("Group Name: ${_user.accessCode}"),
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
      )),
      floatingActionButton: _user.isHost
          ? FloatingActionButton.extended(
              label: Text("Start"),
              onPressed: _startSketching,
            )
          : Container(),
    );
  }
}
