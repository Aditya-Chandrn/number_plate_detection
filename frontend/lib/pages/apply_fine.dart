import 'package:flutter/material.dart';
import 'package:number_plate_detector/api_calls/apply_fine.dart';
import 'package:number_plate_detector/components/button.dart';
import 'package:number_plate_detector/pages/info.dart';
import 'package:number_plate_detector/utils/constants.dart';

class ApplyFine extends StatefulWidget {
  final int userId;

  const ApplyFine({super.key, required this.userId});

  @override
  State<ApplyFine> createState() => _ApplyFineState();
}

class _ApplyFineState extends State<ApplyFine> {
  List<int> selectedReasons = [];

  // 🟢 Apply Fine API Call
  Future<void> _confirm() async {
    try {
      print("****************** here 1 *************");
      print(widget.userId);
      print(selectedReasons);

      final Map<String, dynamic>? updatedDetails = await applyFineApiCall(
        widget.userId,
        selectedReasons,
      );
      print("****************** here 1 *************");
      print(updatedDetails);

      if (updatedDetails != null) {
        // Navigate to Info Page with updated details
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Info(details: updatedDetails),
          ),
        );
      } else {
        throw Exception("Failed to apply fine");
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Apply Fine")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select reasons for applying fine",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 🟢 List of Fine Reasons with Checkboxes
            Expanded(
              child: ListView(
                children:
                    trafficFines.entries.map((entry) {
                      final index = entry.key;
                      final reason = entry.value["reason"];
                      final fine = entry.value["fine"];

                      return CheckboxListTile(
                        title: Text("$reason (₹$fine)"),
                        value: selectedReasons.contains(index),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedReasons.add(index);
                            } else {
                              selectedReasons.remove(index);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 🟢 Buttons (Confirm & Cancel)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Button(
                  name: "Confirm",
                  action: () {
                    if (selectedReasons.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select at least one reason."),
                        ),
                      );
                    } else {
                      _confirm();
                    }
                  },
                ),
                Button(
                  name: "Cancel",
                  action: () {
                    Navigator.pop(context);
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
