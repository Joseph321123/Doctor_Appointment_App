import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Menu Principal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              //En firebase el usuario lo mantiene autenticado despues del login,
              //entonces agregamos ${FirebaseAuth.instance.currentUser
              //ya que eso hace que me de acceso al usuario que esta actualmenete logueado
              // agregamos ?.email ?? "usuario" debido a que si por alguna razon no existe el
              //usuario hace que evite errores
              '"¡Hola, ${FirebaseAuth.instance.currentUser?.email ?? "usuario"}!, en que podemos ayudarte?"',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  height: 100,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Text('Clinic visit'),
                ),
                const SizedBox(width: 16), // espacio horizontal
                Container(
                  width: 130,
                  height: 100,
                  color: Colors.white10,
                  child: const Center(child: Text("Medical Advice")),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 50,
                  color: Colors.white,
                  child: const Center(child: Text("A medical specialist")),
                ),
              ],
            ),

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // hace que el scroll sea lateral
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 50,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(right: 10),
                    child: const Center(child: Text("Widget 1")),
                  ),
                  Container(
                    width: 120,
                    height: 50,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(right: 10),
                    child: const Center(child: Text("Widget 2")),
                  ),
                  Container(
                    width: 120,
                    height: 50,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(right: 10),
                    child: const Center(child: Text("Widget 3")),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 50,
                  color: Colors.white,
                  child: const Center(child: Text("Popular Doctors")),
                ),
              ],
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Image.asset(
                      //ruta de la imagen
                      'assets/images/logo_citas_medicas.jpg',
                      //tamaño de la imagen
                      height: MediaQuery.of(context).size.height * 0.08,
                      //se asegura que la imagen no se distorsione
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text("Doctor name 1"),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("doctor name 2"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("doctor name 3"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("doctor name 4"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("doctor name 5"),
                  ),
                ],
              ),
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
            const SizedBox(height: 20),

            // Boton para perfil
            TextButton(
              onPressed: () {
                // Navegar a la pagina de perfil
                Navigator.pushReplacementNamed(context, Routes.profile);
              },
              child: const Text("Perfil"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
