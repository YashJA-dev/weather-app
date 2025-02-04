import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:rive/rive.dart';
import 'package:weather/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather/components/adaptive_circular_loading.dart';
import 'package:weather/configs/app_colors.dart';
import 'package:weather/configs/app_const.dart';
import 'package:weather/dialog/auto_complete.dart';
import 'package:weather/dialog/notifier.dart';
import 'package:weather/extentions/list_extension.dart';
import 'package:weather/repository/open_weather_api_repo.dart';
import 'package:weather/router/routes_name.dart';
import 'package:weather/screens/home/bloc/home_bloc.dart';
import 'package:weather/screens/home/model/location.dart';
import 'package:weather/screens/home/model/weather.dart';
import 'package:weather/screens/signin/sign_in_screen.dart';
import 'package:weather/services/notification_handler.dart';
import 'package:weather/services/work_manager.dart';
import 'package:workmanager/workmanager.dart';

import 'components/icon_weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateMachineController? _controller;
  SMIInput<double>? timeInput;
  SMIInput<bool>? cloudyInput;
  SMIInput<bool>? rainyInput;
  SMIInput<bool>? isOpenInput;
  @override
  void initState() {
    // NotificationHandler().showNotification("Page", "READY", 2);
    super.initState();
  }

  void _onRiveInit(Artboard artboard) {
    _controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (_controller != null) {
      artboard.addController(_controller!);
      timeInput = _controller!.findInput<double>("time");
      timeInput!.value =
          double.parse(DateFormat('HH.mm').format(DateTime.now()));
      cloudyInput = _controller!.findInput<bool>("cloudy");
      rainyInput = _controller!.findInput<bool>("rainy");
      isOpenInput = _controller!.findInput<bool>("isOpen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        OpenWeatherApiRepo(
          openWeather: OpenWeather(
            apiKey: AppConst.weatherApiKey,
          ),
        ),
      )..add(GetCurrentLocationWeather()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            GoRouter.of(context).pushReplacementNamed(RoutesName.logIn);
          }
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              Notifier(context).showSnackBar(message: state.message);
            } else if (state is HomeLoaded) {
              if (state.weather?.first?.description == "Clouds") {
                cloudyInput!.value = true;
              } else if (state.weather?.first?.description == "Rain") {
                cloudyInput!.value = true;
                rainyInput!.value = true;
              }
            } else if (state is HomeLoading) {
              if (cloudyInput != null) {
                cloudyInput!.value = false;
                rainyInput!.value = false;
              }
            }
          },
          builder: (context, state) => Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(
                state.weather?.first?.location?.address ?? "",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors
                  .transparent, // Set the background color to transparent
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () async {
                      AutoComplete(context).showAutocompleteDialog().then(
                        (value) {
                          if (value?.lat != null && value?.lng != null) {
                            context.read<HomeBloc>().add(
                                  FetchWeather(
                                    Location(
                                      address: value!.description ?? "",
                                      latitude: double.parse(value!.lat!),
                                      longitude: double.parse(value!.lng!),
                                    ),
                                  ),
                                );
                          }
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.black,
                    )),
                IconButton(
                  onPressed: () {
                    // Workmanager().registerOneOffTask(
                    //   "manualTask", // Unique task name
                    //   "manualTask", // Task tag
                    //   inputData: <String, dynamic>{
                    //     // Optional input data
                    //     "reason": "Button clicked",
                    //   },
                    // );

                    context.read<AuthBloc>().add(AuthLoggedOut());
                  },
                  icon: const Icon(Icons.logout),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(GetCurrentLocationWeather());
                  },
                  icon: const Icon(Icons.refresh),
                  color: Colors.black,
                ),
              ],
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: RiveAnimation.asset(
                    AppConst.weatherHomeRiv,
                    fit: BoxFit.fill,
                    onInit: _onRiveInit,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        ((state is HomeLoaded) ? 0.525 : 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (state is HomeLoaded)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Speed: ${state.weather?.first.windSpeed ?? ""} m/s",
                                  style:
                                      const TextStyle(color: AppColors.white),
                                ),
                                const Icon(
                                  Icons.air,
                                  color: AppColors.white,
                                ),
                              ].separator(8),
                            ),
                          ),
                        const DigitalClock(
                          textScaleFactor: 1.7,
                          digitalClockTextColor: AppColors.white,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.44,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.3),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: state is HomeLoading
                              ? const Center(
                                  child: AdaptiveCircularLoading(),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: FittedBox(
                                              child: Text(
                                                "${state.weather?.first?.temperature}°C",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    state.weather?.first
                                                            ?.description ??
                                                        "",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    "Highs ${state.weather?.first?.minTemperature ?? ""} - ${state.weather?.first?.maxTemperature ?? ""}°C",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                )
                                              ].separator(2),
                                            ),
                                          )
                                        ].separator(8),
                                      ),
                                    ),
                                    state.weather == null
                                        ? const Center(
                                            child: Text(
                                              "Some thing went Wrong!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  state.weather!.length - 1,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                Weather weather =
                                                    state.weather![index + 1];
                                                return ListTile(
                                                    leading: Column(
                                                      children: [
                                                        IconWeather(
                                                            weather: weather
                                                                .description!),
                                                        Text(
                                                          DateFormat('EEE')
                                                              .format(DateTime
                                                                      .now()
                                                                  .add(Duration(
                                                                      days:
                                                                          index))),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                    title: Center(
                                                      child: Text(
                                                        weather.description ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    subtitle: Center(
                                                      child: Text(
                                                        weather.longDescription ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    trailing: Text(
                                                      "${state.weather![index + 1].temperature!.toStringAsFixed(0)}°C",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ));
                                              },
                                            ),
                                          )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
