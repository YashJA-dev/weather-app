import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather/main.dart';

import '../screens/home/home_screen.dart';
import '../screens/signin/sign_in_screen.dart';
import 'routes_name.dart';

class RoutesGenerator {
  BuildContext context;
  RoutesGenerator(this.context);
  GoRouter getRoute() {
    final authState = context.read<AuthBloc>().state;
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: RoutesName.logIn,
      redirect: (context, state) {
        AuthState currentState = context.read<AuthBloc>().state;
        log(currentState.runtimeType.toString());
        if (currentState is AuthAuthenticated) {
          return RoutesName.home;
        } else {
          return RoutesName.logIn;
        }
      },
      routes: [
        GoRoute(
          path: RoutesName.home,
          name: RoutesName.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: RoutesName.logIn,
          name: RoutesName.logIn,
          builder: (context, state) => LoginScreen(),
        )
      ],
    );
  }
}
