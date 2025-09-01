import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

IconData getIcon(String skyType) {
  if (skyType == 'Clouds') return WeatherIcons.cloud;
  if (skyType == 'Rain') return WeatherIcons.rain_mix;
  if (skyType == 'Clear') return WeatherIcons.day_sunny;
  return WeatherIcons.day_sunny;
}
