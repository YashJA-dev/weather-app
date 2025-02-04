import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:weather/main.dart';
import 'package:workmanager/workmanager.dart';

import '../../../repository/open_weather_api_repo.dart';
import '../model/weather.dart';
import '../model/location.dart';
part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final OpenWeatherApiRepo openWeatherApiRepo;
  HomeBloc(this.openWeatherApiRepo) : super(HomeLoading(weather: null)) {
    on<GetCurrentLocationWeather>(_getCurrentLocationWeather);
    on<FetchWeather>(_fetchWeather);
  }

  FutureOr<void> _getCurrentLocationWeather(
      GetCurrentLocationWeather event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading(weather: state.weather));
      Position? currentPosition;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      }
      if (currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        Placemark place = placemarks.first;

        WeatherForecastData? weatherData =
            await openWeatherApiRepo.getCurrentWeather(
                latitude: currentPosition.latitude,
                longitude: currentPosition.longitude);

        if (weatherData != null) {
          emit(
            HomeLoaded(
              weather: weatherData.forecastData
                  .map(
                    (weatherData) => Weather(
                      location: Location(
                        address: '${place.locality}, ${place.country}',
                        latitude: currentPosition!.latitude,
                        longitude: currentPosition!.longitude,
                      ),
                      temperature: weatherData!.temperature.currentTemperature,
                      minTemperature: weatherData.temperature.tempMin,
                      maxTemperature: weatherData.temperature.tempMax,
                      windSpeed: weatherData.wind.speed,
                      description:
                          weatherData.details.first.weatherShortDescription,
                      longDescription:
                          weatherData.details.first.weatherLongDescription,
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          emit(HomeError(
              weather: state.weather,
              message: "Some Thing Went Wrong Please Try Again!"));
        }
      }
    } catch (e) {
      emit(
        HomeError(
            weather: state.weather,
            message: "Some Thing Went Wrong Please Try Again!"),
      );
    }
  }

  FutureOr<void> _fetchWeather(
      FetchWeather event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading(weather: state.weather));
      WeatherForecastData? weatherData =
          await openWeatherApiRepo.getCurrentWeather(
              latitude: event.location.latitude,
              longitude: event.location.longitude);
      if (weatherData != null) {
        emit(
          HomeLoaded(
            weather: weatherData.forecastData
                .map(
                  (weatherData) => Weather(
                    location: Location(
                      address: event.location.address,
                      latitude: event.location.latitude,
                      longitude: event.location.longitude,
                    ),
                    temperature: weatherData!.temperature.currentTemperature,
                    minTemperature: weatherData.temperature.tempMin,
                    maxTemperature: weatherData.temperature.tempMax,
                    windSpeed: weatherData.wind.speed,
                    description:
                        weatherData.details.first.weatherShortDescription,
                    longDescription:
                        weatherData.details.first.weatherLongDescription,
                  ),
                )
                .toList(),
          ),
        );
      } else {
        emit(HomeError(
            weather: state.weather,
            message: "Some Thing Went Wrong Please Try Again!"));
      }
    } catch (e) {
      emit(HomeError(
          weather: state.weather,
          message: "Some Thing Went Wrong Please Try Again!"));
    }
  }
}
