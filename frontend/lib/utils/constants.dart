import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

class Constants {
  static const Color theme = Colors.deepPurple;
}

class ApiUri {
  static final String _SERVER_URL = dotenv.env["SERVER_URL"] ?? "http://localhost:8000/api";
  static final Uri DETECT = Uri.parse("$_SERVER_URL/detect");
}
