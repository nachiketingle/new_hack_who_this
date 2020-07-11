import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Network {
  static final String baseURL = DotEnv().env['SERVER_URL'];

  static Future<dynamic> get(String type, Map<String, String> queries) async {
    Map<String, String> headers = Map();
    if(type == null) {
      type = "";
    }
    headers["Content-Type"] = 'application/json';
    String query = convertToQueryString(queries);
    final response = await http.get(baseURL + type + query);
    printResponse("GET", response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> put(String type, Map<String, dynamic> body) async {
    Map<String, String> headers = Map();
    if(type == null) {
      type = "";
    }
    headers["Content-Type"] = 'application/json';
    print("baseURL: " + baseURL);
    final response = await http.put(baseURL + type, body: body);
    printResponse("PUT", response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> post(String type, Map<String, String> body) async {
    Map<String, String> headers = Map();
    if(type == null) {
      type = "";
    }
    headers["Content-Type"] = 'application/json';
    final response = await http.post(baseURL + type, body: body);
    printResponse("POST", response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> delete(String type, Map<String, String> queries) async {
    Map<String, String> headers = Map();
    if(type == null) {
      type = "";
    }
    headers["Content-Type"] = 'application/json';
    final response = await http.put(baseURL + type + convertToQueryString(queries));
    printResponse("DELETE", response);
    return jsonDecode(response.body);
  }

  static String convertToQueryString(Map<String, String> queries) {
    if(queries == null || queries.isEmpty) {
      return "";
    }

    String finalQuery = "?";
    int count = 0;
    queries.forEach((key, val) {
      finalQuery += key + "=" + val;
      if(count < queries.length - 1) {
        finalQuery += "&";
      }
      count++;
    });

    return finalQuery;
  }

  static printResponse(String apiType, http.Response response) {
    print(apiType + " STATUS: " + response.statusCode.toString() + "\n" + response.body);
  }
}