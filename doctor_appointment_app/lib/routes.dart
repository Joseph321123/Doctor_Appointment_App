import 'package:doctor_appointment_app/main_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'password_reset_page.dart';
import 'register_page.dart';
import 'citas_page.dart'; //importamos el archivo donde estara el CRUD de citas

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String passwordReset = '/password_reset';
  static const String register = '/register_page';
  static const String main = '/main';
  //definimos la ruta para la pantalla de citas
  static const String citas = '/citas';

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
      case citas:
        return MaterialPageRoute(builder: (_) => const CitasPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
