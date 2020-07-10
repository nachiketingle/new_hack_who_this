import 'package:flutter/material.dart';
import 'dart:async';
import 'package:new_hack_who_this/Models/User.dart';

class Lobby extends StatefulWidget {

  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {

  User _user;
  bool _loaded = false;
  List<User> _userList = List();
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

  void _startSketching() {
    Navigator.of(context).pushNamed('/chooseWord');
  }

  void _loadUsers() async {
    Timer(Duration(milliseconds: 500),() => null);
    int origLength = _userList.length;
    _userList.add(_user);
    _userList.add(User.min(name: "Baron"));
    _userList.add(User.min(name: "Bevin"));
    _userList.add(User.min(name: "Bacho"));

    await Future.delayed(Duration(seconds: 1));

    for(int i = origLength; i < _userList.length; i++) {
      _animatedListKey.currentState.insertItem(i, duration: Duration(milliseconds: 500));
    }

  }

  List<User> _sortUsers() {
    _userList.sort();
    return _userList;
  }

  Widget _userBuilder(User user, int index, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      key: ValueKey<int>(index),
      sizeFactor: animation,
      child: ListTile(
        title: Text(_userList[index].name),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_loadUsers();
  }

  @override
  Widget build(BuildContext context) {

    if(!_loaded) {
      _loaded = true;
      _user = ModalRoute.of(context).settings.arguments;
      _loadUsers();
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
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  return _userBuilder(_userList[index], index, context, animation);
                },
              ),
            ),
          ],
        )
      ),
      floatingActionButton: _user.isHost ? FloatingActionButton.extended(
        label: Text("Start"),
        onPressed: _startSketching,
      ) : Container(),
    );
  }
}