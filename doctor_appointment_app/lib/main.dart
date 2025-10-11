import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'register_page.dart'; // Importa la página de registro
import 'password_reset_page.dart'; // Importamos la página de recuperación

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Login de prueba', home: LoginPage());
  }
}

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
      appBar: AppBar(title: const Text("Login Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen centrada debajo del título
              Center(
                child: Image.asset(
                  'assets/images/logo_citas_medicas.jpg', // Ruta de la imagen
                  height: 150, // Ajusta el tamaño de la imagen
                  fit:
                      BoxFit.contain, // Asegura que la imagen no se distorsione
                ),
              ),
              const SizedBox(
                height: 40,
              ), // Espacio entre la imagen y el formulario
              //campo de correo
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electronico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu correo";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              //compo de contraseña
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
              const SizedBox(height: 24),

              // Botón "Olvido su contraseña?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navegar a la pagina de recuperacion de contraseña
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordResetPage(),
                      ),
                    );
                  },
                  child: const Text("¿Olvidó su contraseña?"),
                ),
              ),
              const SizedBox(height: 24),

              //boton de login
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
              const SizedBox(height: 20),

              // Boton para crear una nueva cuenta
              TextButton(
                onPressed: () {
                  // Navegar a la pagina de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text("¿No tienes una cuenta? Crear una nueva"),
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sesion cerrada")),
                  );
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
