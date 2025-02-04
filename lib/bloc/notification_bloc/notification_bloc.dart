import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/app/api/api_response.dart';
import 'package:weather/repository/notification_repo.dart';
import 'package:workmanager/workmanager.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(NotificationInitial()) {
    on<FetchNotificationEvent>(_fetchNotification);
  }

  FutureOr<void> _fetchNotification(
      FetchNotificationEvent event, Emitter<NotificationState> emit) async {}
}
