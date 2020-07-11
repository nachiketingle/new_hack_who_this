import './Network.dart';

class GroupServices {
  static Future<String> createGroup(String groupName, String name) async {
    Map<String, dynamic> json = Map();
    json['groupName'] = groupName;
    json['name'] =  name;
    print("Creating a group");
    Map<String, dynamic> response = await Network.put("create-group", json);
    print("Create group response: " + response['accessCode']);
    return response['accessCode'];
  }

  static Future<Map<String, dynamic>> joinGroup(String accessCode, String name) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    print("Joining a group");
    Map<String, dynamic> list = await Network.put('join-group', json);
    return list;
  }

  static Future<Map<String, dynamic>> startGame(String accessCode) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    print("Starting the game");
    Map<String, dynamic> wordChoices = await Network.put('start-game', json);
    return wordChoices;
  }
}