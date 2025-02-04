part of "home_bloc.dart";

abstract class HomeState extends Equatable {
  final List<Weather>? weather;
  const HomeState({required this.weather});

  @override
  List<Object?> get props => [weather];
}

class HomeInitial extends HomeState {
  HomeInitial({required super.weather});
}

class HomeLoading extends HomeState {
  HomeLoading({required super.weather});
}

class HomeLoaded extends HomeState {
  HomeLoaded({required super.weather});

  @override
  List<Object> get props => [];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required super.weather, required this.message});

  @override
  List<Object> get props => [message];
}
