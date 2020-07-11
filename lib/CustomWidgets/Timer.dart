import 'package:flutter/material.dart';
import 'dart:async' as async;

/// This widget shows a countdown timer. It callbacks when the timer reaches 0
class Timer extends StatefulWidget {
  Timer({Key key, @required this.duration, @required this.callback}):
        super(key: key);
  _TimerState createState() => _TimerState();

  final Function callback;
  final int duration;
}

class _TimerState extends State<Timer> {

  async.Timer asyncTimer;
  int duration;

  @override
  void initState() {
    super.initState();
    duration = widget.duration;
    asyncTimer = async.Timer.periodic(Duration(seconds: 1), (timer) {
      duration -= 1;
      if(mounted) {
        setState(() {

        });
      }
      if(duration <= 0) {
        timer.cancel();
        widget.callback.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      duration.toString(),
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 50,
        color: Colors.black
      ),
    );
  }

}