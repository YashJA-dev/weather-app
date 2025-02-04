import 'package:open_weather_client/enums/languages.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:weather/repository/base_api_repo.dart';
import 'package:weather/screens/home/bloc/home_bloc.dart';

class OpenWeatherApiRepo extends BaseApiRepo {
  final OpenWeather _openWeather;
  OpenWeatherApiRepo({required OpenWeather openWeather})
      : _openWeather = openWeather;
  Future<WeatherForecastData?> getCurrentWeather(
      {required double longitude, required double latitude}) async {
    try {
      return _openWeather.fiveDaysWeatherForecastByLocation(
        latitude: latitude,
        longitude: longitude,
        language: Languages.ENGLISH,
        weatherUnits: WeatherUnits.METRIC,
      );
      // return _openWeather.fiveDaysWeatherForecastByCityName(
      //   cityName: "Chennai",
      //   language: Languages.ENGLISH,
      //   weatherUnits: WeatherUnits.METRIC,
      // );
    } catch (e) {
      return null;
    }
  }

  Future<WeatherData?> getCurrentLocationWeatherToday(
      {required double longitude, required double latitude}) async {
    try {
      return _openWeather.currentWeatherByLocation(
        latitude: latitude,
        longitude: longitude,
        language: Languages.ENGLISH,
        weatherUnits: WeatherUnits.METRIC,
      );
    } catch (e) {
      return null;
    }
  }
}
