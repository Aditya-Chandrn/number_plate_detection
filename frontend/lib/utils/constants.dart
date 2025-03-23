import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const Color theme = Colors.deepPurple;
}

class ApiUrls {
  static late final String _serverUrl;
  static late final Uri detect;
  static late final Uri applyFine;

  static Future<void> init() async {
    // await dotenv.load();
    // _serverUrl = dotenv.env["SERVER_URL"] ?? "http://localhost:8000/api";
    _serverUrl = "http://192.168.29.165:8000/api";

    detect = Uri.parse("$_serverUrl/detect");
    applyFine = Uri.parse("$_serverUrl/apply-fine");
  }
}

// 🟢 Traffic Fine Reasons
final Map<int, Map<String, dynamic>> trafficFines = {
  0: {"reason": "Speeding over limit", "fine": 500},
  1: {"reason": "Jumping a red light", "fine": 1000},
  2: {"reason": "Driving without a license", "fine": 2000},
  3: {"reason": "Not wearing a seatbelt", "fine": 300},
  4: {"reason": "Using a mobile phone while driving", "fine": 1000},
  5: {"reason": "Illegal parking", "fine": 500},
  6: {"reason": "Driving under the influence", "fine": 5000},
  7: {"reason": "Riding without a helmet", "fine": 500},
  8: {"reason": "No valid insurance", "fine": 1500},
  9: {"reason": "Overloading passengers", "fine": 800},
};
