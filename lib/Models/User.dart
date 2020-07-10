import 'package:flutter/cupertino.dart';

class User {

  String name;
  String groupName;
  String accessCode;
  bool isHost;
  static User currUser;

  User({@required this.name, @required this.groupName, @required this.accessCode, this.isHost:false});

  User.min({@required this.name});

}