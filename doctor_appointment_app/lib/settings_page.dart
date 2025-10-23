import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'info_page.dart';
import 'routes.dart';

// Widget sin estado porque la pantalla de configuración no cambia dinámicamente
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia de FirebaseAuth para poder cerrar sesión
    final _auth = FirebaseAuth.instance;

    return Scaffold(
      // AppBar en la parte superior con el título de la página
      appBar: AppBar(
        title: const Text("Configuración"), // Título del AppBar
        automaticallyImplyLeading:
            false, // Oculta el botón de "volver" (back), ya que esta pantalla es parte de una pestaña principal
      ),

      body: ListView(
        children: [
          // Opción: Perfil
          ListTile(
            leading: const Icon(Icons.person), // Ícono de usuario
            title: const Text("Perfil"), // Título del item
            onTap: () {
              // Navega a la pantalla de perfil usando las rutas definidas
              Navigator.pushNamed(context, Routes.profile);
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip), // Ícono de privacidad
            title: const Text("Privacidad"),
            onTap: () {
              // Navega a una pantalla que muestra información estática sobre privacidad
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InfoPage(
                    title: "Privacidad", // Título de la AppBar en InfoPage
                    text:
                        "Aquí va la política de privacidad...", // Contenido de ejemplo
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info), // Ícono de información
            title: const Text("Sobre nosotros"),
            onTap: () {
              // Navega a InfoPage con texto informativo sobre la app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InfoPage(
                    title: "Sobre nosotros",
                    text: "Esta aplicación fue creada para facilitar...",
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout), // Ícono de cerrar sesión
            title: const Text("Cerrar sesión"),
            onTap: () async {
              // Cierra la sesión del usuario actual con FirebaseAuth
              await _auth.signOut();

              // Redirige al usuario a la pantalla de login,
              // reemplazando toda la navegación anterior (no se puede volver atrás)
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          ),
        ],
      ),
    );
  }
}
