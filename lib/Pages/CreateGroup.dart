import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Models/User.dart';
import 'package:new_hack_who_this/Network/GroupServices.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Helpers/Constants.dart';

class CreateGroup extends StatefulWidget {
  final Function(String, String) onCreate;
  final VoidCallback onEdit;
  CreateGroup({Key key, @required this.onCreate, @required this.onEdit})
      : super(key: key);
  CreateGroupState createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CarouselController buttonCarouselController = CarouselController();
  FocusNode _groupNameFocus = FocusNode();
  FocusNode _nameFocus = FocusNode();

  void reset() {
    buttonCarouselController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _createGroup(BuildContext context) async {
    if (!_isValid()) {
      _displaySnackBar("Please enter all valid fields");
      return;
    }

    // signal parent creating group
    widget.onCreate(_groupNameController.text.trim(), _usernameController.text.trim());


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
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _groupNameFocus.dispose();
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
                TextSpan(text: "   Create Group"),
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
            _groupNameFocus.requestFocus();
          },
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            focusNode: _groupNameFocus,
            controller: _groupNameController,
            onEditingComplete: () {
              buttonCarouselController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              _nameFocus.requestFocus();
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: "Group Name",
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
              _createGroup(context);
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: "Your Name",
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
              viewportFraction: 1,
              onPageChanged: (int newPage, CarouselPageChangedReason reason) {
                // if intenionally swiped
                if (reason == CarouselPageChangedReason.manual) {
                  widget.onEdit();
                }
              }),
          itemCount: 3,
          itemBuilder: _formBuilder),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Constants.primaryColor.withOpacity(.5),
              Constants.secondaryColor.withOpacity(.5)
            ]),
      ),
    );
  }
}
