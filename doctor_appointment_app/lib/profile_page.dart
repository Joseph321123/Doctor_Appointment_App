import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Controladores de los campos del formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController enfermedadesController = TextEditingController();

  bool _loading = false;
  //_loading es un interruptor visual:
  //true mueestra un "cargando..." y bloquea la UI
  //flase muestra la pantalla normal

  @override
  void initState() {
    super.initState();
    _loadUserData();
  } // aqui creamos la clase que cargara los datos del usuario al iniciar

  //cargar datos del usuario desde firestore
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('usuarios').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      nombreController.text = data['nombre'] ?? '';
      telefonoController.text = data['telefono'] ?? '';
      enfermedadesController.text =
          data['enfermedades'] ?? ''; //(antes historial medico)
    }
  }

  //guardar datos del usuario en Firestore
  Future<void> _saveUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    await _firestore.collection('usuarios').doc(user.uid).set({
      'nombre': nombreController.text.trim(),
      'telefono': telefonoController.text.trim(),
      'enfermedades': enfermedadesController.text
          .trim(), // (antes historial medico)
      'email': user.email,
      'uid': user.uid,
    });

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Informacion guardada exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Correo: ${user?.email ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    //formulario
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: telefonoController,
                      decoration: const InputDecoration(labelText: 'Telefono'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: enfermedadesController,
                      decoration: const InputDecoration(
                        labelText: 'enfermedades',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: const Text("Guardar informacion"),
                    ),
                    const SizedBox(height: 30),

                    //boton para volver al menu principal
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      },
                      child: const Text("Volver al menu principal"),
                    ),
                    const SizedBox(height: 20),

                    //boton para cerrar sesion
                    ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacementNamed(context, Routes.login);
                      },
                      child: const Text("Cerrar sesion"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
