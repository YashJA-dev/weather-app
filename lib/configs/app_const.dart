import 'dart:convert';

class AppConst {
  AppConst._();
  // OPEN WEATHER API KEY
  static String weatherApiKey = "YOUR_API_KEY";
  // google place API KEY
  static String googleApiKey = "YOUR_API_KEY";
  // GEMMINAI API KEY
  static String geminaiApiKey = "YOUR_API_KEY";
  // RIV
  static String weatherHomeRiv = "assets/weather_app_demo.riv";

  // propt
  static String alertPrompt =
      "show funny and carring alert less then 100 characters for following date time ${DateTime.now()} if its night or day show accordingly on the basis of it";
}
