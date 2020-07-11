import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Helpers/Constants.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CarouselController buttonCarouselController = CarouselController();
  FocusNode _accessCodeFocus = FocusNode();
  FocusNode _nameFocus = FocusNode();

  void _joinGroup() async {
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
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _accessCodeFocus.dispose();
    super.dispose();
  }

  Widget _formBuilder(BuildContext context, int itemIndex) {
    List<Widget> form = [
      ButtonTheme(
        buttonColor: Constants.buttonColor,
        minWidth: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.height * 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: RaisedButton(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "   Join Group"),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Constants.primaryColor,
                    ),
                  ),
                )
              ],
              style: TextStyle(
                  color: Constants.textColor,
                  fontSize: 18,
                  fontFamily: "Montserrat"),
            ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            buttonCarouselController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            _accessCodeFocus.requestFocus();
          },
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            focusNode: _accessCodeFocus,
            controller: _accessCodeController,
            onEditingComplete: () {
              buttonCarouselController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              _nameFocus.requestFocus();
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: "Access Code",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.all(Radius.circular(10)),
                  borderSide: new BorderSide(),
                )),
          )),
      Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            focusNode: _nameFocus,
            controller: _usernameController,
            onSubmitted: (s) {
              _joinGroup();
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: "Name",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.all(Radius.circular(10)),
                  borderSide: new BorderSide(),
                )),
          )),
    ];
    return Center(child: form[itemIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider.builder(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.12,
              aspectRatio: MediaQuery.of(context).size.height /
                  MediaQuery.of(context).size.width,
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1),
          itemCount: 3,
          itemBuilder: _formBuilder),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Constants.primaryColor.withOpacity(.5),
              Constants.secondaryColor.withOpacity(.5)
            ]),
      ),
    );
  }
}
