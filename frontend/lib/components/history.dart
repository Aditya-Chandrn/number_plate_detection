import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const History({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        const SizedBox(height: 10),
        ...history.map(
          (h) => Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: h["status"] == true ? Colors.green : Colors.red,
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[200], // Light background
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to start
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h["reason"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text("₹${h["fine"]}"), // Fixed string interpolation
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  h["timestamp"].toString().replaceAll("T", " "),
                ), // Fixed timestamp formatting
              ],
            ),
          ),
        ),
      ],
    );
  }
}
