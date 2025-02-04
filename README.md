# Weather App

A Flutter-based weather app that provides real-time weather updates using the OpenWeather API, Google Places API, and Gemini AI for intelligent alerts. The app also includes animations powered by Rive.

# Features

Real-time Weather Data: Fetch weather data using the OpenWeather API.
Location Search: Use Google Places API to search for locations.
AI-Powered Alerts: Gemini AI generates funny and caring alerts based on the time of day.
Animations: Rive animations for a smooth user experience.
Setup Instructions

# Screen Shots

1. Clone the Repository

Clone the repository to your local machine:


# Screen Shots


Signup Page                                                                                                                  |  Weather Page            | SignUp Screen
:----------------------------------------------------------------------------------------------------------------------------:|:-------------------------:|:-----------------------------------:
<img src="https://github.com/user-attachments/assets/a6999f5d-8dc3-4bae-a715-b6fa3fc2997c" width="200"> | <img src="https://github.com/user-attachments/assets/5b9d8363-8ccf-4288-bc20-a347d77a2822" width="200"> | <img src="https://github.com/user-attachments/assets/0f2bccbb-7cf0-4449-a5fa-db21561e19cb" width="200">


```
git clone https://github.com/YashJA-dev/weather-app.git
```

2. Add API Keys

Replace the placeholder API keys in the AppConst class with your actual API keys:

```
class AppConst {
  AppConst._();
  // OPEN WEATHER API KEY
  static String weatherApiKey = "YOUR_OPENWEATHER_API_KEY";
  // GOOGLE PLACES API KEY
  static String googleApiKey = "YOUR_GOOGLE_PLACES_API_KEY";
  // GEMINI AI API KEY
  static String geminaiApiKey = "YOUR_GEMINI_AI_API_KEY";
  // RIVE ANIMATION FILE
  static String weatherHomeRiv = "assets/weather_app_demo.riv";

  // PROMPT FOR ALERTS
  static String alertPrompt =
      "show funny and caring alert less than 100 characters for the following date time ${DateTime.now()}. If it's night or day, show accordingly.";
}
```
3. Install Dependencies

Run the following command to install the required dependencies:


```
flutter pub get
```

4. Run the App

Launch the app on an emulator or physical device:
```
flutter run
```
## APP WORKING

https://drive.google.com/file/d/1Ez_FPVskwQCjf5Kmg1DxF36hLOD-SQzZ/view?usp=share_link



