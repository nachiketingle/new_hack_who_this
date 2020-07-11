import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _createGroup() async {
    if (!_isValid()) {
      _displaySnackBar("Please enter all valid fields");
      return;
    }

    // get info from form
    String code = _accessCodeController.text;
    String name = _usernameController.text.trim();

    // send network request
    GroupServices.joinGroup(code, name).then((value) {
      // if had an error
      if (value.containsKey('error')) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(value['error']),
        ));
      } 
      // if joined successfully
      else {
        List<dynamic> _temp = value['members'];
        List<User> allUsers = List();
        for (String username in _temp) {
          User user = User(
              name: username,
              groupName: value['groupName'],
              accessCode: code,
              isHost: false);
          allUsers.add(user);
          if (username == name) {
            User.currUser = user;
          }
        }

        Navigator.pushNamed(context, "/lobby", arguments: allUsers);
      }
    });
  }

  bool _isValid() {
    return _accessCodeController.text.length > 0 &&
        _usernameController.text.length > 0;
  }

  void _displaySnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("JoinGroup"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: _accessCodeController,
                  decoration: InputDecoration(hintText: "Access Code"),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(hintText: "Your Name"),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Join"),
          onPressed: () {
            _createGroup();
          },
        ),
      ),
    );
  }
}
