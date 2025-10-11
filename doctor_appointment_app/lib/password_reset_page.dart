import 'package:flutter/material.dart'; // Importa el paquete de Flutter para crear la interfaz grafica de la app
import 'package:firebase_auth/firebase_auth.dart'; // Importa el paquete de Firebase Authentication para manejar la autenticacion

// Esta es la clase que representa la pantalla de recuperacion de contraseña.
class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({
    super.key,
  }); // Constructor de la clase con un parametro de clave (super.key) que se usa para pasar la clave al widget padre

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState(); // El metodo createState crea el estado de la pantalla de recuperacion
}

// La clase _PasswordResetPageState define la logica y la UI (interfaz) de la pantalla de recuperacion de contraseña.
class _PasswordResetPageState extends State<PasswordResetPage> {
  final _emailController =
      TextEditingController(); // Controlador del campo de texto que recibira el correo del usuario
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Instancia de FirebaseAuth para interactuar con Firebase Authentication

  // Funcion para enviar el correo de recuperacion de contraseña
  Future<void> _sendPasswordResetEmail() async {
    try {
      // Intentamos enviar un correo de recuperacion a la direccion que el usuario ingreso
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

      // Si el correo se envio correctamente, mostramos un SnackBar con un mensaje de exito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Te hemos enviado un correo para recuperar tu contraseña.",
          ),
        ),
      );

      // Despues de enviar el correo, regresamos a la pantalla de inicio de sesion (Login)
      Navigator.pop(
        context,
      ); // Regresa a la pantalla anterior (en este caso, main)
    } on FirebaseAuthException catch (e) {
      // Si ocurre un error (como que el correo no existe), mostramos un mensaje con el error
      String message = "Ocurrio un error al intentar enviar el correo";

      // Si el error es de "usuario no encontrado", mostramos un mensaje especifico
      if (e.code == 'user-not-found') {
        message = "No se encontro un usuario con este correo.";
      }

      // Mostramos el mensaje de error usando un SnackBar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aqua empieza el diseño de la pantalla
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
      ), // Barra de navegacion con el titulo "Recuperar Contraseña"
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Añadimos un padding (margen)
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Centramos el contenido de la pantalla verticalmente
          children: [
            // Este es el texto que le indica al usuario que ingrese su correo
            const Text(
              'Introduce tu correo electronico para recibir un enlace de recuperacion:',
              style: TextStyle(
                fontSize: 16,
              ), // Establecemos el tamaño de la fuente
              textAlign: TextAlign.center, // Centra el texto horizontalmente
            ),
            const SizedBox(
              height: 20,
            ), // Añadimos un espacio de 20 pixeles entre el texto y el siguiente widget
            // Campo de texto donde el usuario debe ingresar su correo electronico
            TextField(
              controller:
                  _emailController, // Vinculamos este TextField con el controlador _emailController
              decoration: const InputDecoration(
                labelText: 'Correo electronico', // Etiqueta del campo de texto
                border:
                    OutlineInputBorder(), // Establecemos el borde del campo de texto
              ),
            ),
            const SizedBox(height: 20),

            // Boton que al presionarlo llama a la funcion _sendPasswordResetEmail
            ElevatedButton(
              onPressed:
                  _sendPasswordResetEmail, // El boton llama a la funcion _sendPasswordResetEmail cuando se presiona
              child: const Text(
                'Enviar enlace de recuperacion',
              ), // El texto dentro del boto
            ),
          ],
        ),
      ),
    );
  }
}
