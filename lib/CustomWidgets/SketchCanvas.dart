import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';

class SketchCanvas extends StatefulWidget {
  SketchCanvas({Key key}) : super(key: key);

  SketchCanvasState createState() => SketchCanvasState();
}

class SketchCanvasState extends State<SketchCanvas> {
  final List<Line> _lineList = List();
  Line _line;
  List<Offset> points;
  static Color chosenColor;
  static double thickness;
  static int width;
  static int height;
  int currLine = 0;
  bool endLine = true;

  @override
  void initState() {
    width = -1;
    height = -1;
    super.initState();
  }

  /// Get data image from canvas and convert to string
  Future<String> getImageData() async {
    ByteData bd = await SketchPainter(_lineList).getImageData();
    Uint8List ints = bd.buffer.asUint8List();
    String s = base64Encode(ints.toList());
    return s;
  }

  void undoLine() {
    if(_lineList.isNotEmpty) {
      setState(() {
        _lineList.removeLast();
      });
    }
  }

  void clearCanvas() {
    setState(() {
      _lineList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (width == -1) {
      width = (MediaQuery.of(context).size.width * 0.8).round();
    }
    if (height == -1) {
      height = (MediaQuery.of(context).size.height * 0.6).round();
    }

    width = (MediaQuery.of(context).size.width * 0.8).round();
    height = (MediaQuery.of(context).size.height * 0.6).round();

    SketchPainter painter = SketchPainter(_lineList);

    return GestureDetector(
      //onTap: () => getImageData(),
      onTapDown: (details) {
        setState(() {
          if(endLine == true) {
            points = List();
            _line = Line(
                points,
                Paint()
                  ..color = chosenColor
                  ..strokeWidth = thickness
                  ..isAntiAlias = true);
            _lineList.add(_line);
            _line.points.add(details.localPosition);
            _line.points.add(details.localPosition);
            endLine = false;
          }
        });
      },

      onTapUp: (details) {
        endLine = true;
      },

      onPanStart: (details) {
        setState(() {
          if(endLine == true){
            points = List();
            _line = Line(
                points,
                Paint()
                  ..color = chosenColor
                  ..strokeWidth = thickness
                  ..isAntiAlias = true);
            _lineList.add(_line);
            endLine = false;
          }
          _line.points.add(details.localPosition);
          _line.points.add(details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _line.points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          currLine++;
          endLine = true;
        });
      },
      child: CustomPaint(
        foregroundPainter: painter,
        child: Container(
          height: height * 1.0,
          width: width * 1.0,
          color: Colors.green[50],
        ),
      ),
    );
  }
}

class SketchPainter extends CustomPainter {
  List<Line> lines;
  ui.PictureRecorder recorder = new ui.PictureRecorder();
  SketchPainter(this.lines) : super();
  static Canvas activeCanvas;

  Future<ByteData> getImageData() async {
    int width = SketchCanvasState.width;
    int height = SketchCanvasState.height;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    this.paint(Canvas(recorder), new Size(width * 1.0, height * 1.0));

    ui.Picture picture = recorder.endRecording();
    ui.Image img = await picture.toImage(width, height);
    ByteData data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;
    for (Line line in lines) {
      List<Offset> points = line.points;
      paint = line.paint;

      for (int i = 0; i < points.length - 1; i++) {
        if (!size.contains(points[i]) || !size.contains(points[i + 1]))
          continue;
        //canvas.drawPoints(PointMode.points, [offsets[i]], paint);
        if(points[i] == points[i + 1]) {
          canvas.drawPoints(ui.PointMode.points, [points[i], points[i+1]], paint);
        }
        else {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorPalette extends StatefulWidget {
  ColorPalette({this.undo, this.clear});

  _ColorPaletteState createState() => _ColorPaletteState();

  final Function undo;
  final Function clear;

}

class _ColorPaletteState extends State<ColorPalette> {
  Color chosenColor;
  double setThickness;

  List<Color> _list = <Color>[
    Colors.black,
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.white
  ];

  List<Widget> _colorButtons() {
    List<Widget> buttons = List();

    for (Color color in _list) {
      buttons.add(Flexible(
        flex: 1,
        child: RaisedButton(
          shape: CircleBorder(),
          color: color,
          onPressed: () {
            updateColor(color);
          },
        ),
      ));
    }

    return buttons;
  }

  void updateColor(Color color) {
    SketchCanvasState.chosenColor = color;
    setState(() {
      chosenColor = color;
    });
  }

  void updateThickness(double thickness) {
    SketchCanvasState.thickness = thickness;
    setState(() {
      setThickness = thickness;
    });
  }

  @override
  void initState() {
    super.initState();
    chosenColor = _list.first;
    SketchCanvasState.chosenColor = chosenColor;
    setThickness = 3;
    SketchCanvasState.thickness = setThickness;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: chosenColor,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _colorButtons(),
              )
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Slider(
                value: setThickness,
                min: 1,
                max: 10,
                onChanged: (val) {
                  updateThickness(val);
                },
                activeColor: chosenColor,
              ),
            ),

            IconButton(
              icon: Icon(Icons.undo),
              color: chosenColor,
              onPressed: () {
                // remove the end of line
                widget.undo.call();
              },
            ),

            IconButton(
              icon: Icon(Icons.clear),
              color: chosenColor,
              onPressed: () {
                // delete list
                widget.clear.call();
              },
            )

          ],
        )

      ],
    );
  }
}


class Line {
  List<Offset> points = List();
  Paint paint = Paint();

  Line(this.points, this.paint);
}
