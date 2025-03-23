import 'dart:convert';

import 'package:number_plate_detector/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> detectApiCall(String base64String) async {
  try {
    final response = await http.post(
      ApiUrls.detect,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"base64_string": base64String}),
    );
    return jsonDecode(response.body)["details"];
  } catch (error) {
    print("Error detecting vehicle: $error");
    return null;
  }
}
