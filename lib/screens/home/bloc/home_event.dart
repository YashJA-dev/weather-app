part of "home_bloc.dart";

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends HomeEvent {
  final Location location;

  const FetchWeather(this.location);

  @override
  List<Object> get props => [location];
}

class RefreshWeather extends HomeEvent {
  final String cityName;

  const RefreshWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class GetCurrentLocationWeather extends HomeEvent {}
