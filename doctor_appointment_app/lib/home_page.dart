import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //  Necesario para obtener el nombre en la base de datos
import 'routes.dart';
import 'popular_doctors_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _nombreUsuario;

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  // Carga el nombre del usuario desde Firebase Auth o Firestore
  Future<void> _cargarNombreUsuario() async {
    final user = _auth.currentUser;

    if (user != null) {
      String? displayName = user.displayName;

      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _nombreUsuario = displayName;
        });
      } else {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            _nombreUsuario = doc.data()!['nombre'] ?? user.email ?? 'Usuario';
          });
        } else {
          setState(() {
            _nombreUsuario = user.email ?? 'Usuario';
          });
        }
      }
    } else {
      setState(() {
        _nombreUsuario = 'Usuario desconocido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Principal"),
        automaticallyImplyLeading: false, //quita la flecha de retroceso
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Muestra el nombre real del usuario
            Text(
              _nombreUsuario == null
                  ? "Cargando usuario..."
                  : "¡Hola, $_nombreUsuario!, ¿en qué podemos ayudarte?",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Boton 1
                ElevatedButton(
                  onPressed: () {
                    // Accion del primer boton
                    Navigator.pushNamed(context, Routes.citas);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(130, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 32, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Clinic Visit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Botón 2
                ElevatedButton(
                  onPressed: () {
                    // Acción del segundo botón
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(130, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.help_outline, size: 32, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Medical Advice',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  color: Colors.white,
                  child: const Center(child: Text("What are your sympstoms?")),
                ),
              ],
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 140,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Fiebre",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Dolor de cabeza",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Tos",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Dolor muscular",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 60,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Cansancio",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //seccion de doctores populares
            const PopularDoctorsSection(),

            const SizedBox(height: 20),

            //boton para cerrar sesion
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: const Text("Cerrar sesion"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
