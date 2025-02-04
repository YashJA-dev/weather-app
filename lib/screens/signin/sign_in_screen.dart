import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:weather/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather/configs/app_colors.dart';
import 'package:weather/dialog/notifier.dart';
import 'package:weather/router/routes_name.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            GoRouter.of(context).pushReplacementNamed(RoutesName.home);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: const RiveAnimation.asset("assets/weather.riv"),
                  ),
                  const SizedBox(height: 40),
                  _buildSignInButton(
                    Buttons.google,
                    "Sign up with Google",
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoggedIn());
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSignInButton(
                    Buttons.facebook,
                    "Sign up with Facebook",
                    onPressed: () {
                      Notifier(context)
                          .showSnackBar(message: "Please Use Google Signup");
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSignInButton(
                    Buttons.appleDark,
                    "Sign up with Apple",
                    onPressed: () {
                      Notifier(context)
                          .showSnackBar(message: "Please Use Google Signup");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(Buttons button, String text,
      {required Function onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: SignInButton(
        button,
        text: text,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
    );
  }
}
