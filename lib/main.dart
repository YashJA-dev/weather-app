import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/services/open_weather_api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/app/api/api_response.dart';
import 'package:weather/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather/configs/app_colors.dart';
import 'package:weather/configs/app_const.dart';
import 'package:weather/firebase_options.dart';
import 'package:weather/repository/google_auth_repo.dart';
import 'package:weather/repository/notification_repo.dart';
import 'package:weather/repository/open_weather_api_repo.dart';
import 'package:weather/services/notification_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'router/routes_generator.dart';
import 'services/work_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHandler().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authBloc = AuthBloc(
    googleAuthRepo: GoogleAuthRepo(
      auth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ),
  )..add(AuthCheckLoggedIn());

  // await authBloc.stream.firstWhere((state) => state is! AuthInitial);

  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (create) => authBloc)],
    child: WeatherApp(),
  ));
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  void initState() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      routerConfig: RoutesGenerator(context).getRoute(),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  NotificationRepository notificationRepository = NotificationRepository();
  OpenWeatherApiRepo openWeatherApiRepo = OpenWeatherApiRepo(
      openWeather: OpenWeather(
    apiKey: AppConst.weatherApiKey,
  ));
  Workmanager().executeTask((task, inputData) async {
    await NotificationHandler().init();
    Position? currentPosition;
    log("EXEC1");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      WeatherData? weatherData =
          await openWeatherApiRepo.getCurrentLocationWeatherToday(
              longitude: currentPosition.longitude,
              latitude: currentPosition.latitude);
      log("EXEC2");

      if (weatherData != null) {
        log("EXEC3");

        APIResponse response = await notificationRepository.fetchNotification(
            weatherData.details.first.weatherLongDescription);
        if (response is SuccessResponse) {
          log("EXEC 4");

          String message = response.rawData["candidates"]?[0]["content"]
                  ?["parts"][0]?["text"] ??
              "Some thing went wrong";
          NotificationHandler().showNotification("Weather", message, 2);
        }
      }
    }
    return Future.value(true);
  });
}


// void callbackDispatcher() {
//   // Initialize the notifications plugin here
//   final notificationsPlugin = FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: DarwinInitializationSettings(),
//   );

//   notificationsPlugin.initialize(initializationSettings);

 
//   Workmanager().executeTask((task, inputData) async {
//     log("LOG ExECUTED");

    
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'weather_updates_channel', // Channel ID (your_channel_id4)
//       'Weather Updates',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await notificationsPlugin!.show(
//       0,
//       "Weather",
//       "message",
//       platformChannelSpecifics,
//     );
//     // } else {
//     //   log("ERROR1");
//     // }
//     // } else {
//     //   log("ERROR2");
//     // }
//     // }
//     return Future.value(true);
//   });
// }
