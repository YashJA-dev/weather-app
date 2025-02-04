part of "notification_bloc.dart";

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final String message;
  NotificationLoaded(this.message);
}

class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}
