import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {

  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Choose Word"),
        ),
      ),
    );
  }
}