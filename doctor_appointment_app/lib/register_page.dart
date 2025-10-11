// register_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // GlobalKey para identificar el formulario y validar sus campos
  final _formKey = GlobalKey<FormState>();
  // Controladores para manejar los campos de texto (email y contraseña)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instancia de FirebaseAuth para manejar la autenticacion de usuarios
  // como vimos en clase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la aplicacion con el titulo.
      appBar: AppBar(title: const Text("Crear una nueva cuenta")),

      // Cuerpo de la pantalla que contiene el formulario.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margen alrededor del formulario
        child: Form(
          key: _formKey, // Asociamos la clave global con el formulario
          child: Column(
            children: [
              // Campo de texto para el correo electronico
              TextFormField(
                controller:
                    emailController, // Controlador para manejar el texto ingresado
                decoration: const InputDecoration(
                  labelText:
                      "Correo electrónico", // Etiqueta que se muestra en el campo
                  border: OutlineInputBorder(), // Borde del campo de texto
                ),
                validator: (value) {
                  // Valida que el campo no este vacio
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu correo"; // Mensaje de error si el campo está vacío
                  }
                  return null; // Retorna null si la validación es exitosa
                },
              ),
              const SizedBox(height: 16), // Espaciado entre campos
              // Campo de texto para la contraseña
              TextFormField(
                controller:
                    passwordController, // Controlador para la contraseña
                decoration: const InputDecoration(
                  labelText:
                      "Contraseña", // Etiqueta que se muestra en el campo
                  border: OutlineInputBorder(), // Borde del campo de texto
                ),
                obscureText:
                    true, // Oculta el texto mientras se escribe (para la contraseña)
                validator: (value) {
                  // Valida que el campo de contraseña no este vacio
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa una contraseña"; // Mensaje de error si el campo esta vacio
                  }
                  return null; // Retorna null si la validacion es exitosa
                },
              ),
              const SizedBox(height: 24), // Espaciado entre campos y boton
              // Boton para crear una nueva cuenta
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Si el formulario es valido, intenta registrar al usuario
                    try {
                      // Intentamos crear una nueva cuenta con el correo y la contraseña ingresada
                      UserCredential userCredential = await _auth
                          .createUserWithEmailAndPassword(
                            email: emailController.text
                                .trim(), // Correo del usuario
                            password: passwordController.text
                                .trim(), // Contraseña del usuario
                          );
                      // Si el registro es exitoso, mostramos un mensaje de bienvenida
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Cuenta creada para ${userCredential.user!.email}", // Mostramos el correo del usuario registrado
                          ),
                        ),
                      );

                      // Volver a la pantalla anterior (Login)
                      Navigator.pop(context); // Regresar a la pagina de login
                    } on FirebaseAuthException catch (e) {
                      // Si ocurre un error, mostramos el mensaje de error
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.message!)));
                    }
                  }
                },
                child: const Text("Crear cuenta"), // Texto del boton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
