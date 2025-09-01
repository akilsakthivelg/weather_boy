import 'package:flutter/material.dart';
import 'dart:ui';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({
    super.key,
    required this.temp,
    required this.comment,
    required this.icon,
  });

  final String temp, comment;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity - 10,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '$temp °C',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  icon,
                  SizedBox(height: 16),
                  Text(comment, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
