import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo({
    required this.info,
    required this.icon,
    required this.data,
    super.key,
  });

  final String info;
  final IconData icon;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 10),
        Text(info, style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text(data, style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
