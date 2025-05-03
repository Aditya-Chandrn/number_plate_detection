import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:number_plate_detector/components/button.dart';
import 'package:number_plate_detector/pages/apply_fine.dart';
import 'package:number_plate_detector/pages/home.dart';
import 'package:number_plate_detector/utils/constants.dart';
import 'package:number_plate_detector/utils/helpers.dart';

class Info extends StatelessWidget {
  final Map<String, dynamic> details;

  const Info({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (details['image'] != null && details['image'].isNotEmpty) {
      try {
        imageBytes = base64Decode(details['image']);
      } catch (e) {
        print("Error decoding image: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("User Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 User Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // 🟢 User Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:
                          imageBytes != null
                              ? Image.memory(
                                imageBytes,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                              : const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                    ),
                    const SizedBox(width: 16),

                    // 🟢 User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${details['fname']} ${details['lname']}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Vehicle: ${details['vehicle_number']} (${details['vehicle_type']})",
                          ),
                          Text("Age: ${calculateAge(details['dob'])} years"),
                          Text("Gender: ${details['gender']}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟢 Fine History Section
            const Text(
              "Fine History:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: details["history"].length,
                itemBuilder: (context, index) {
                  final history = details["history"][index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: history["status"] ? Colors.green : Colors.red,
                          width: 5,
                        ),
                      ),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fine: ₹${history['fine']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "- ${history['reasons'].map((id) => trafficFines[id]!["reason"]).join('\n- ')}",
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            history["timestamp"].split("T").join("  "),
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 🟢 Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Button(
                  name: "Apply Fine",
                  action: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ApplyFine(userId: details["user_id"]),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Button(
                  name: "Capture Image",
                  action: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
