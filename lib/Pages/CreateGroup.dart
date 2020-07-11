import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';

class CreateGroup extends StatefulWidget {
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _createGroup() async {
    if (!_isValid()) {
      _displaySnackBar("Please enter all valid fields");
      return;
    }

    GroupServices.createGroup(
            _groupNameController.text.trim(), _usernameController.text.trim())
        .then((accessCode) {
      List<User> allUsers = List();
      // If successful, create user and go to next page
      User user = User(
        name: _usernameController.text.trim(),
        groupName: _groupNameController.text.trim(),
        accessCode: accessCode,
        isHost: true,
      );
      allUsers.add(user);
      User.currUser = user;
      Navigator.pushNamed(context, "/lobby", arguments: allUsers);
    });
  }

  bool _isValid() {
    return _groupNameController.text.length > 0 &&
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
          title: Text("CreateGroup"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(hintText: "Group Name"),
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
          label: Text("Create"),
          onPressed: () {
            _createGroup();
          },
        ),
      ),
    );
  }
}
