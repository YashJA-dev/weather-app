import 'package:flutter/material.dart';

class IconWeather extends StatelessWidget {
  final String weather;
  const IconWeather({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconWeather(),
      color: Colors.white,
    );
  }

  _getIconWeather() {
    switch (weather) {
      case "Clouds":
        return Icons.cloud;
      case "Clear":
        return Icons.sunny;
      case "Rain":
        return Icons.thunderstorm;
      default:
        return Icons.error;
    }
  }
}
