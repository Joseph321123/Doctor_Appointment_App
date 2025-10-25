import 'package:flutter/material.dart';
import 'home_page.dart';
import 'messages_page.dart';
import 'settings_page.dart';
import 'citas_page.dart';

// MainScreen es un widget con estado porque cambiará de contenido cuando el usuario toque las pestañas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// Esta es la clase interna que maneja el estado de MainScreen
class _MainScreenState extends State<MainScreen> {
  // Variable que guarda el índice de la pestaña seleccionada en la barra inferior
  int _selectedIndex = 0;

  // Lista de páginas que se mostrarán según la pestaña seleccionada
  final List<Widget> _pages = const [
    HomePage(), // Página principal (inicio)
    MessagesPage(), // Página de mensajes
    SettingsPage(), // Página de configuración
    CitasPage(), // Pagina de citas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra la página correspondiente al índice seleccionado
      body: _pages[_selectedIndex],

      // Barra de navegación inferior con 4 elementos
      bottomNavigationBar: BottomNavigationBar(
        // Índice actualmente seleccionado
        currentIndex: _selectedIndex,

        // Función que se ejecuta cuando el usuario toca una opción
        onTap: (index) => setState(() => _selectedIndex = index),

        backgroundColor: Colors.blue, // Color de fondo de la barra
        selectedItemColor: Colors.white, // Ícono y texto seleccionados
        unselectedItemColor: Colors.black, // Ícono y texto no seleccionados
        type: BottomNavigationBarType.fixed, // Evita animaciones raras
        // Lista de elementos (íconos y etiquetas) de la barra inferior
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícono de casa
            label: 'Inicio', // Texto debajo del ícono
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message), // Ícono de mensaje
            label: 'Mensajes', // Texto debajo del ícono
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Ícono de configuración
            label: 'Configuración', // Texto debajo del ícono
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), // Ícono de citas
            label: 'Citas', // Texto debajo del ícono
          ),
        ],
      ),
    );
  }
}
