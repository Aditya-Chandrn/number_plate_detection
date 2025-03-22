import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final Map<String, dynamic> data;

  const Info({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, dynamic>>> dataSet = [
      [
        {"First Name": data["fname"]},
        {"Last Name": data["lname"]},
      ],
      [
        {"Age": data["age"]},
        {"Gender": data["gender"]},
      ],
      [
        {"Address": data["address"]},
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(data["vehicle_number"]?.toString() ?? "Vehicle Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              dataSet.map((row) {
                return Row(
                  children:
                      row.map((entry) {
                        String key = entry.keys.first;
                        String value =
                            entry.values.first?.toString() ??
                            ""; // ✅ Convert to String safely

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$key: ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              }).toList(),
        ),
      ),
    );
  }
}
