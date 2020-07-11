import 'package:flutter/material.dart';
import 'dart:convert';

class Sketch {
  String base64String;
  Image image;
  Sketch(this.base64String) {
    image = Image.memory(base64Decode(this.base64String), fit: BoxFit.contain,);
  }
}