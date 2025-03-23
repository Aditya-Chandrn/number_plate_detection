import 'dart:convert';

import 'package:number_plate_detector/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> applyFineApiCall(
  int userId,
  List<int> reasons,
) async {
  try {
    final response = await http.post(
      ApiUrls.applyFine,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "reasons": reasons}),
    );

    return jsonDecode(response.body)["details"];
  } catch (error) {
    print("Error applying fine: $error");
    return null;
  }
}
