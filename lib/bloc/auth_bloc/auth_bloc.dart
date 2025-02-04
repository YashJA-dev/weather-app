import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/model/user.dart';
import 'package:weather/repository/google_auth_repo.dart';
import 'package:workmanager/workmanager.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthRepo googleAuthRepo;
  AuthBloc({required this.googleAuthRepo}) : super(AuthInitial()) {
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthCheckLoggedIn>(_onAuthCheckLoggedIn);
    on<AuthLoggedOut>(_authLogOut);
  }

  Future<void> _onAuthLoggedIn(
      AuthLoggedIn event, Emitter<AuthState> emit) async {
    try {
      User? model = await googleAuthRepo.signIn();
      if (model == null) {
        emit(const AuthError("Some Thing Went Wrong!"));
      } else {
        Position? currentPosition;
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        }
        emit(AuthAuthenticated(UserModel(
            email: model.email ?? "",
            userId: model.uid,
            name: model.displayName ?? "")));
        // start showing notification
        Workmanager().registerPeriodicTask(
          "Periodic Task2",
          "task3",
          frequency: const Duration(
            hours: 1,
          ),
        );
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  // void checkTaskStatus() async {
  //   Workmanager(). ("Periodic Task2").then((workInfo) {
  //     if (workInfo != null) {
  //       print("Task State: ${workInfo.state}");
  //       if (workInfo.state == WorkInfoState.enqueued ||
  //           workInfo.state == WorkInfoState.running) {
  //         print("Task is running or enqueued.");
  //       } else {
  //         print("Task is not running.");
  //       }
  //     } else {
  //       print("Task not found.");
  //     }
  //   });
  // }

  Future<void> _onAuthCheckLoggedIn(
      AuthCheckLoggedIn event, Emitter<AuthState> emit) async {
    try {
      final isSignedIn = await googleAuthRepo.isSignedIn();
      if (isSignedIn) {
        final user = await googleAuthRepo.getCurrentUser();
        if (user != null) {
          emit(
            AuthAuthenticated(
              UserModel(
                  email: user.email ?? "",
                  userId: user.uid,
                  name: user.displayName ?? ""),
            ),
          );
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  FutureOr<void> _authLogOut(
      AuthLoggedOut event, Emitter<AuthState> emit) async {
    try {
      await googleAuthRepo.signOut();
      await Workmanager().cancelByUniqueName("Periodic Task2");
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
