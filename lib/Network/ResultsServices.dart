import 'package:flutter/cupertino.dart';

import './Network.dart';

class ResultsServices {
  static Future<Map<String, dynamic>> results(String accessCode) async {
    Map<String, String> json = Map();
    json['accessCode'] = accessCode;
    print("Getting Results...");
    Map<String, dynamic> response = await Network.get("results", json);
    print("Results response: " + response.toString());
    return response;
  }

  static Future<Map<String, dynamic>> resultsDetails(
      String accessCode, String word) async {
    Map<String, String> json = Map();
    json['accessCode'] = accessCode;
    json['word'] = word;
    print("Getting Result Details for " + word);
    Map<String, dynamic> response = await Network.get("results-details", json);
    print("Result Details response: " + response.toString());
    return response;
  }
}
