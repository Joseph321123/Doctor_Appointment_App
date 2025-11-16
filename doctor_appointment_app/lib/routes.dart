import 'package:doctor_appointment_app/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'password_reset_page.dart';
import 'register_page.dart';
import 'citas_page.dart'; //importamos el archivo donde estara el CRUD de citas
import 'dashboard_page.dart'; //pantalla para médicos

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String passwordReset = '/password_reset';
  static const String register = '/register_page';
  static const String main = '/main';
  //definimos la ruta para la pantalla de citas
  static const String citas = '/citas';

  // Función para obtener el rol del usuario actual desde Firestore
  static Future<String> getUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();
    return doc['rol'] ?? 'Paciente';
  }

  // Función para obtener la pantalla principal según el rol
  static Future<Widget> getMainScreenWidget() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si no hay usuario logueado, enviamos a login
      return LoginPage();
    }

    final role = await getUserRole(user.uid);

    if (role == 'Médico') {
      return const DashboardPage();
    } else {
      return const MainScreen();
    }
  }

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
        // Usamos FutureBuilder para decidir qué pantalla mostrar según rol
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<Widget>(
            future: getMainScreenWidget(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else {
                return snapshot.data!;
              }
            },
          ),
        );
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
