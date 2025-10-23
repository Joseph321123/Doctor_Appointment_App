import 'package:doctor_appointment_app/main_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'password_reset_page.dart';
import 'register_page.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String passwordReset = '/password_reset';
  static const String register = '/register_page';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case passwordReset:
        return MaterialPageRoute(builder: (_) => const PasswordResetPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case main:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
