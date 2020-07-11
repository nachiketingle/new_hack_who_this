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

  static Future<String> latestSketch(
      String accessCode, String word) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['word'] = word;
    print("Requestion Sketch for " + word);
    Map<String, dynamic> response = await Network.put("latest-sketch", json);
    return response["sketch"];
  }
}
