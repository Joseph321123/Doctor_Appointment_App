import 'package:flutter/material.dart';

class PopularDoctorsSection extends StatelessWidget {
  const PopularDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de doctores (puedes editar, agregar o quitar fácilmente)
    final List<Map<String, dynamic>> doctors = [
      {
        'nombre': 'Dr. Juan Pérez',
        'especialidad': 'Cardiólogo',
        'estrellas': 5,
        'imagen': 'assets/images/doctor.jpg',
      },
      {
        'nombre': 'Dra. Ana López',
        'especialidad': 'Dermatóloga',
        'estrellas': 4,
        'imagen': 'assets/images/doctora.jpg',
      },
      {
        'nombre': 'Dr. Carlos Gómez',
        'especialidad': 'Pediatra',
        'estrellas': 4,
        'imagen': 'assets/images/doctor.jpg',
      },
      {
        'nombre': 'Dra. María Torres',
        'especialidad': 'Neuróloga',
        'estrellas': 5,
        'imagen': 'assets/images/doctora.jpg',
      },
      {
        'nombre': 'Dr. Luis Fernández',
        'especialidad': 'Traumatólogo',
        'estrellas': 3,
        'imagen': 'assets/images/doctor.jpg',
      },
      {
        'nombre': 'Dra. Sofía Ramírez',
        'especialidad': 'Oftalmóloga',
        'estrellas': 5,
        'imagen': 'assets/images/doctora.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ), //  espacio con bordes
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            width: 180,
            height: 50,
            color: Colors.white,
            child: const Center(
              child: Text(
                "Popular Doctors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Cuadrícula de doctores
          GridView.builder(
            itemCount: doctors.length,
            shrinkWrap: true, // necesario dentro de SingleChildScrollView
            physics:
                const NeverScrollableScrollPhysics(), // evita conflicto de scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 por fila
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // proporción cuadrada
            ),
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Imagen redondeada
                    ClipOval(
                      child: Image.asset(
                        doctor['imagen'],
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Nombre
                    Text(
                      doctor['nombre'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Especialidad
                    Text(
                      doctor['especialidad'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    // Estrellas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < doctor['estrellas']
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
