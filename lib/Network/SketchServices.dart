import 'package:flutter/widgets.dart';

import './Network.dart';

class SketchServices {
  static Future<Map<String, dynamic>> submitWord(
      String accessCode, String name, String word) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    json['word'] = word;
    print("Selecting " + word);
    Map<String, dynamic> response = await Network.put("submit-word", json);
    print("Submit Word response: " + response.toString());
    return response;
  }

  static Future<String> latestSketch(String accessCode, String word) async {
    Map<String, String> json = Map();
    json['accessCode'] = accessCode;
    json['word'] = word;
    print("Requesting Sketch for " + word);
    Map<String, dynamic> response = await Network.get("latest-sketch", json);
    print("Response from latest sketch " + response.toString());
    return response["sketch"];
  }

  static void submitSketch(
      String accessCode, String sketch, String name) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    json['sketch'] = sketch;
    print("Submitting Sketch");
    Map<String, dynamic> response = await Network.put("submit-sketch", json);
    print("Submit Sketch Response: " + response["message"]);
  }

  static Future<List<dynamic>> promptGuess(
      String accessCode, String name) async {
    Map<String, String> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    print("Prompting for Guess Options");
    Map<String, dynamic> response = await Network.get("prompt-guess", json);
    print("Prompt Guess REsponse: " + response.toString());
    return response["words"];
  }

  static void submitGuess(String accessCode, String guess, String name) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    json['guess'] = guess;
    print("Submitting Guess");
    Map<String, dynamic> response = await Network.put("submit-guess", json);
    print("Submit Guess Response: " + response["message"]);
  }
}
