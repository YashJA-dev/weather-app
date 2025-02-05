import 'dart:convert';

class AppConst {
  AppConst._();
  static String weatherApiKey = "191caaa9537fd722a7bf8d4219f4ae9b";
  static String googleApiKey = "AIzaSyCTexnTVsp_ccEWjRXw2CR1dXy5gVfPkvc";
  static String geminaiApiKey = "AIzaSyDsHEr-Q0YrNGfdIXV3GAzkadUQPJ_0PN4";

  // RIV
  static String weatherHomeRiv = "assets/weather_app_demo.riv";

  // propt
  static String alertPrompt =
      "show funny and carring alert less then 100 characters for following date time ${DateTime.now()} if its night or day show accordingly on the basis of it";
}
