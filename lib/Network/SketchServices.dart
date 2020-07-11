import './Network.dart';

class SketchServices {
    static Future<Map<String, dynamic>> submitWord(String accessCode, String name, String word) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    json['name'] = name;
    json['word'] = word;
    print("Selecting " + word);
    Map<String, dynamic> response = await Network.put("submit-word", json);
    print("Submit Word response: " + response.toString());
    return response;
  }
}