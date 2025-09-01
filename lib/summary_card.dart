import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.time,
    required this.icon,
    required this.temp,
    super.key,
  });

  final String time;
  final Icon icon;
  final String temp;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            icon,
            SizedBox(height: 8),
            Text('$temp °C', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
