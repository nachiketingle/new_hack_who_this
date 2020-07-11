import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Helpers/Constants.dart';

class FormSlider extends StatefulWidget {
  final String action;
  final String field1;
  final String field2;
  final List<Color> gradient;
  final Function(String, String) onSubmit;
  final VoidCallback onSlide;
  final Function(String) onError;
  FormSlider(
      {Key key,
      @required this.action,
      @required this.onSubmit,
      @required this.onSlide,
      @required this.field1,
      @required this.field2,
      @required this.gradient,
      this.onError})
      : super(key: key);
  FormSliderState createState() => FormSliderState();
}

class FormSliderState extends State<FormSlider> {
  TextEditingController _field1Controller = TextEditingController();
  TextEditingController _field2Controller = TextEditingController();
  CarouselController buttonCarouselController = CarouselController();
  FocusNode field1Focus = FocusNode();
  FocusNode field2Focus = FocusNode();

  void reset() {
    buttonCarouselController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _submit(BuildContext context) async {
    if (!_isValid()) {
      widget.onError("Please enter all valid fields");
    } else {
      // signal parent to submit info
      widget.onSubmit(
          _field1Controller.text.trim(), _field2Controller.text.trim());
    }
  }

  bool _isValid() {
    return _field1Controller.text.length > 0 &&
        _field2Controller.text.length > 0;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    field2Focus.dispose();
    field1Focus.dispose();
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
                TextSpan(text: "   " + widget.action),
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
            field1Focus.requestFocus();
          },
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            focusNode: field1Focus,
            controller: _field1Controller,
            onEditingComplete: () {
              buttonCarouselController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              field2Focus.requestFocus();
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: widget.field1,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.all(Radius.circular(10)),
                  borderSide: new BorderSide(),
                )),
          )),
      Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: TextField(
            focusNode: field2Focus,
            controller: _field2Controller,
            onSubmitted: (s) {
              _submit(context);
            },
            decoration: new InputDecoration(
                isDense: true,
                labelText: widget.field2,
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
                  widget.onSlide();
                }
              }),
          itemCount: 3,
          itemBuilder: _formBuilder),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: widget.gradient),
      ),
    );
  }
}
