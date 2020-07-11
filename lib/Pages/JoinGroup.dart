import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';

class JoinGroup extends StatefulWidget {

  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _createGroup() async {
    if(!_isValid()) {
      _displaySnackBar("Please enter all valid fields");
      return;
    }

    User user = User(
        name: _usernameController.text,
        groupName: 'random group name',
        accessCode: _accessCodeController.text,
    );
    User.currUser = user;
    Navigator.of(context).pushNamed('/lobby', arguments: user);
  }

  bool _isValid() {
    return _accessCodeController.text.length > 0 && _usernameController.text.length > 0;
  }

  void _displaySnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(text),
        )
    );
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
                  decoration: InputDecoration(
                      hintText: "Group Name"
                  ),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: "Your Name"
                  ),
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