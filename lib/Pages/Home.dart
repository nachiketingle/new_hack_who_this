import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';
import '../Helpers/Constants.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';
import 'package:new_hack_who_this/CustomWidgets/FormSlider.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _keyboardVisible = false;
  bool _loading = false;
  Widget _joinGroupWidget;
  Widget _createGroupWidget;
  GlobalKey<FormSliderState> joinKey = GlobalKey();
  GlobalKey<FormSliderState> createKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );
    _joinGroupWidget = FormSlider(
      action: "Join Group",
      field1: "Access Code",
      field2: "Name",
      gradient: [
        Constants.primaryColor.withOpacity(.5),
        Constants.secondaryColor.withOpacity(.5)
      ],
      key: joinKey,
      onSlide: () {
        createKey.currentState.reset();
      },
      onError: (error) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error),
        ));
      },
      onSubmit: (code, name) async {
        setState(() {
          _loading = true;
        });

        // show bubble
        await Future.delayed(Duration(seconds: 1));

        // send network request
        GroupServices.joinGroup(code, name).then((value) {
          // enable buttons for future
          new Future.delayed(const Duration(milliseconds: 10), () {
            setState(() {
              _loading = false;
            });
          });

          // if had an error
          if (value.containsKey('error')) {
            // display error
            _scaffoldKey.currentState.showSnackBar(SnackBar(
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
      },
    );
    _createGroupWidget = FormSlider(
      action: "Create Group",
      field1: "Group Name",
      field2: "Your Name",
      gradient: [
        Constants.secondaryColor.withOpacity(.5),
        Constants.primaryColor.withOpacity(.5)
      ],
      key: createKey,
      onSlide: () {
        joinKey.currentState.reset();
      },
      onError: (error) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error),
        ));
      },
      onSubmit: (groupName, userName) async {
        setState(() {
          _loading = true;
        });

        // show loading bubble
        await Future.delayed(Duration(seconds: 1));

        // call api
        GroupServices.createGroup(groupName, userName).then((accessCode) {
          // enable buttons for future
          new Future.delayed(const Duration(milliseconds: 10), () {
            setState(() {
              _loading = false;
            });
          });

          List<User> allUsers = List();
          // If successful, create user and go to next page
          User user = User(
            name: userName,
            groupName: groupName,
            accessCode: accessCode,
            isHost: true,
          );
          allUsers.add(user);
          User.currUser = user;
          Navigator.pushNamed(context, "/lobby", arguments: allUsers);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_keyboardVisible);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Opacity(
                opacity: .4,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover),
                  ),
                )),
            Opacity(
              opacity: .6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Constants.primaryColor,
                        Constants.secondaryColor
                      ]),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      if (!_keyboardVisible)
                        Image.asset('assets/logo.png', scale: 1),
                      if (!_keyboardVisible)
                        Text(
                          'Connect with your friends!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Constants.textColor),
                        ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .15),
                    ],
                  ),
                  if (!_loading)
                    Column(
                      children: <Widget>[
                        _createGroupWidget,
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _joinGroupWidget
                      ],
                    ),
                  if (_loading)
                    Transform.scale(
                      child: SpinKitDoubleBounce(color: Constants.primaryColor),
                      scale: 2.5,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
