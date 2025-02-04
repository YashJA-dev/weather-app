import 'package:weather/screens/home/model/location.dart';

class Weather {
  final double? temperature;
  final double? minTemperature;
  final double? maxTemperature;
  final double? windSpeed;
  final String? description;
  final String? longDescription;
  final Location location;

  Weather({
    required this.location,
    this.temperature,
    this.minTemperature,
    this.maxTemperature,
    this.windSpeed,
    this.description,
    this.longDescription,
  });

  @override
  List<Object?> get props => [
        temperature,
        minTemperature,
        maxTemperature,
        windSpeed,
        description,
        location,
      ];

  Weather copyWith({
    double? temperature,
    double? minTemperature,
    double? maxTemperature,
    double? windSpeed,
    String? description,
    Location? location,
  }) {
    return Weather(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      windSpeed: windSpeed ?? this.windSpeed,
      description: description ?? this.description,
    );
  }
}
