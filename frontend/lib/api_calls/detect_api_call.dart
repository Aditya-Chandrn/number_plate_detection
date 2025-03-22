import "dart:convert";
import "package:http/http.dart" as http;
import "package:number_plate_detection/utils/constants.dart";

Future<Map<String, dynamic>?> detectApiCall() async {
  try {
    // final response = await http.get(ApiUri.DETECT);
    Map<String, dynamic> data = {
      "fname": "John",
      "lname": "Doe",
      "age": 26,
      "gender": "Male",
      "vehicle_number": "MH 1A A 2345",
      "address": "123, B-1, XYZ Apartments, Maharashtra, India - 123456",
    };

    return data;
  } catch (e) {
    print(e);
  }
  return null;
}
