import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:open_weather_client/services/open_weather_api_service.dart';
import 'package:weather/app/api/api_response.dart';
import 'package:weather/configs/app_const.dart';
import 'package:weather/main.dart';
import 'package:weather/repository/notification_repo.dart';
import 'package:weather/repository/open_weather_api_repo.dart';
import 'package:weather/services/notification_handler.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerCustom {
  static final WorkManagerCustom _instance = WorkManagerCustom._internal();

  static NotificationRepository notificationRepository =
      NotificationRepository();
  static OpenWeatherApiRepo openWeatherApiRepo = OpenWeatherApiRepo(
      openWeather: OpenWeather(
    apiKey: AppConst.weatherApiKey,
  ));

  factory WorkManagerCustom() {
    return _instance;
  }

  WorkManagerCustom._internal();

  static void callbackDispatcher() {
    log("LOG ExECUTED 1");

    Workmanager().executeTask((task, inputData) async {
      log("LOG ExECUTED");
      Position? currentPosition;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        WeatherData? weatherData =
            await openWeatherApiRepo.getCurrentLocationWeatherToday(
                longitude: currentPosition.longitude,
                latitude: currentPosition.latitude);
        if (weatherData != null) {
          APIResponse response = await NotificationRepository()
              .fetchNotification(
                  weatherData.details.first.weatherLongDescription);
          if (response is SuccessResponse) {
            String message = response.rawData["candidates"]?[0]["content"]
                    ?["parts"][0]?["text"] ??
                "Some thing went wrong";
            NotificationHandler()
                .showNotification("get ", "HI THIS IS MESSAGE", 1);
          }
        }
      }
      return Future.value(true);
    });
  }
}
