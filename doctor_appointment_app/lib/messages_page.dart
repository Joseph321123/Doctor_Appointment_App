import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensajes"),
        automaticallyImplyLeading: false, // sin flecha de retroceso
      ),

      //lista de mensajes personalizados
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          MessageCard(
            nombre: "Dr. Juan Pérez",
            mensaje: "Hola, ¿cómo te has sentido últimamente?",
            imagen: 'assets/images/doctor.jpg',
          ),
          MessageCard(
            nombre: "Dra. María López",
            mensaje: "Recuerda tomar tu medicación después de comer.",
            imagen: 'assets/images/doctora.jpg',
          ),
          MessageCard(
            nombre: "Dr. Carlos Gómez",
            mensaje: "Tu cita está confirmada para mañana a las 10 a.m.",
            imagen: 'assets/images/doctor.jpg',
          ),
          MessageCard(
            nombre: "Dra. Fernanda Rojas",
            mensaje: "Te enviaré los resultados de tus exámenes.",
            imagen: 'assets/images/doctora.jpg',
          ),
          MessageCard(
            nombre: "Dr. Luis Ramírez",
            mensaje: "Por favor confirma tu asistencia al control mensual.",
            imagen: 'assets/images/doctor.jpg',
          ),
        ],
      ),
    );
  }
}

///  Widget reutilizable para mostrar cada mensaje individual
class MessageCard extends StatelessWidget {
  final String nombre;
  final String mensaje;
  final String imagen;

  const MessageCard({
    super.key,
    required this.nombre,
    required this.mensaje,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // sombra
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipOval(
          child: Image.asset(imagen, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(mensaje, style: const TextStyle(color: Colors.black87)),
        onTap: () {},
      ),
    );
  }
}
