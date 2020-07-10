import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';

class CreateGroup extends StatefulWidget {

  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _createGroup() async {
    if(!_isValid()) {
      _displaySnackBar("Please enter all valid fields");
      return;
    }
    
    User user = User(
      name: _usernameController.text,
      groupName: _groupNameController.text,
      accessCode: 'yada',
      isHost: true
    );
    User.currUser = user;
    Navigator.of(context).pushNamed('/lobby', arguments: user);

  }

  bool _isValid() {
    return _groupNameController.text.length > 0 && _usernameController.text.length > 0;
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
          label: Text("Create"),
          onPressed: () {
            _createGroup();
          },
        ),
      ),
    );
  }
}