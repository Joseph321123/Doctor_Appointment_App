import 'package:flutter/material.dart';

// MessagesPage es un widget sin estado (StatelessWidget) porque su contenido no cambia internamente
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar que aparece en la parte superior de la pantalla
      appBar: AppBar(
        title: const Text("Mensajes"), // Título de la AppBar
        // automaticallyImplyLeading: false,
        // Si se descomenta, oculta el botón de "volver" automáticamente
        // Útil si esta pantalla es parte de una pestaña y no fue empujada con Navigator
      ),

      // Cuerpo de la pantalla: una lista vertical que simula conversaciones
      body: ListView.builder(
        itemCount: 5, // Número de elementos (mensajes simulados)
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(
              'msg_$index',
            ), // Clave única para identificar el widget al arrastrar
            direction: DismissDirection
                .endToStart, // Permite deslizar de derecha a izquierda
            onDismissed: (_) {
              // Acción al eliminar (actualmente vacía)
              // Aquí podrías mostrar un Snackbar o eliminar el mensaje
            },

            // Fondo rojo que aparece al deslizar, indicando que se puede eliminar
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight, // Alinea el ícono a la derecha
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ), // Ícono de eliminar
            ),

            // El contenido del mensaje simulado
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person), // Ícono del doctor simulado
              ),
              title: Text("Doctor ${index + 1}"), // Nombre del doctor
              subtitle: const Text(
                "Mensaje de prueba...",
              ), // Texto simulado del mensaje
              onTap: () {
                // Acción al tocar el mensaje (por ahora vacía)
              },
            ),
          );
        },
      ),
    );
  }
}
