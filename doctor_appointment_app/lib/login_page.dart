import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DoctorAppointmentApp")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //imagen centrada debajo del titulo
              Center(
                child: Image.asset(
                  //ruta de la imagen
                  'assets/images/logo_citas_medicas.jpg',
                  //tamaño de la imagen
                  height: MediaQuery.of(context).size.height * 0.3,
                  //se asegura que la imagen no se distorsione
                  fit: BoxFit.contain,
                ),
              ),
              //El espacio que hay entre la imagen y el campo de inicio de
              //sesion
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electronico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa a tu correo";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu contraseña";
                  }
                  return null;
                },
              ),
              // Botón "Olvido su contraseña?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navegar a la pagina de recuperacion de contraseña
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.passwordReset,
                    );
                  },
                  child: const Text("¿Olvidó su contraseña?"),
                ),
              ),
              const SizedBox(height: 14),

              //Si la valida el correo y la contraseña y
              //dice el correo y bienvenido, ademas
              //redirige a home
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await _auth
                          .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Bienvenido ${userCredential.user!.email}",
                          ),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, Routes.main);
                    } on FirebaseAuthException catch (e) {
                      String message = "";
                      if (e.code == 'user-not-found') {
                        message = "Usuario no encontrado";
                      } else if (e.code == 'wrong-password') {
                        message = "Contraseña incorrecta";
                      } else {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  }
                },
                child: const Text("Iniciar sesion"),
              ),
              const SizedBox(height: 16),

              //cerramos sesion
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sesion cerrada")),
                  );
                },
                child: const Text("Cerrar sesion"),
              ),
              const SizedBox(height: 14),
              // Boton para crear una nueva cuenta
              TextButton(
                onPressed: () {
                  // Navegar a la pagina de registro
                  Navigator.pushReplacementNamed(context, Routes.register);
                },
                child: const Text("¿No tienes una cuenta? Crear una nueva"),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}
