import 'package:flutter/material.dart';
import 'package:new_hack_who_this/Helpers/Constants.dart';

class SketchCanvas extends StatefulWidget {
  SketchCanvas({Key key}) :
        super(key: key);

  _SketchCanvasState createState() => _SketchCanvasState();

}

class _SketchCanvasState extends State<SketchCanvas> {

  final List<Line> _lineList = List();
  Line _line;
  List<Offset> points;
  static Color chosenColor;
  static int thickness;
  int currLine = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          points = List();
          _line = Line(points, Paint()
            ..color = chosenColor
            ..strokeWidth = 3
            ..isAntiAlias = true);
          _lineList.add(_line);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _line.points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          //_offsets.add(Offset(0, 0));
          currLine++;
        });
      },
      child: CustomPaint(
        foregroundPainter: SketchPainter(_lineList),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          color: Colors.green[50],
        ),
      ),
    );
  }

}

class SketchPainter extends CustomPainter {

  List<Line> lines;
  SketchPainter(this.lines): super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepPurple
      ..isAntiAlias = true
      ..strokeWidth = 3.0;

    for(Line line in lines) {
      List<Offset> points = line.points;
      paint = line.paint;
      for(int i = 0; i < points.length - 1; i++) {
        if(!size.contains(points[i]) || !size.contains(points[i+1]))
          continue;
        //canvas.drawPoints(PointMode.points, [offsets[i]], paint);
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorPalette extends StatefulWidget {

  ColorPalette();

  _ColorPaletteState createState() => _ColorPaletteState();

}

class _ColorPaletteState extends State<ColorPalette> {

  Color chosenColor;
  int setThickness;

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

    for(Color color in _list) {
      buttons.add(
        Flexible(
          flex: 1,
          child: RaisedButton(
            shape: CircleBorder(),
            color: color,
            onPressed: () {
              updateColor(color);
            },
          ),
        )
      );
    }

    return buttons;
  }

  void updateColor(Color color) {
    _SketchCanvasState.chosenColor = color;
    setState(() {
      chosenColor = color;
    });
  }

  void updateThickness(int thickness) {
    _SketchCanvasState.thickness = thickness;
    setState(() {
      setThickness = thickness;
    });
  }

  @override
  void initState() {
    super.initState();
    chosenColor = _list.first;
    _SketchCanvasState.chosenColor = chosenColor;
    setThickness = 3;
    _SketchCanvasState.thickness = setThickness;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: chosenColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _colorButtons(),
          ),
        ),
      ),
    );
  }

}

class Line {
  List<Offset> points = List();
  Paint paint = Paint();

  Line(this.points, this.paint);

}