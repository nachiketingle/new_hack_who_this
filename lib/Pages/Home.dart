import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Helpers/Constants.dart';
import './JoinGroup.dart';
import './CreateGroup.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _keyboardVisible = false;
  Widget _joinGroupWidget;
  Widget _createGroupWidget;

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
    _joinGroupWidget = JoinGroup();
    _createGroupWidget = CreateGroup();
  }

  @override
  Widget build(BuildContext context) {
    print(_keyboardVisible);
    return SafeArea(
        child: Scaffold(
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
                  Column(
                    children: <Widget>[
                      _createGroupWidget,
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      _joinGroupWidget
                    ],
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
