part of "notification_bloc.dart";

abstract class NotificationEvent {}

class FetchNotificationEvent extends NotificationEvent {
  final String weather;
  FetchNotificationEvent(this.weather);
}
