import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _motivoController = TextEditingController();
  String? _nombreUsuario;
  DateTime? _fechaSeleccionada;
  String? _citaEnEdicionId; // ID de la cita que estamos editando

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  // Cargar el nombre del usuario desde Firestore
  Future<void> _cargarNombreUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Intenta obtener el displayName de Firebase Auth primero
      String? displayName = user.displayName;

      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _nombreUsuario = displayName;
        });
      } else {
        // Si no hay displayName, busca en la colección 'usuarios'
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            // Asume que tienes un campo 'nombre' en tu documento de usuario
            _nombreUsuario =
                doc.data()!['nombre'] ?? user.email ?? 'Usuario Anónimo';
          });
        } else {
          // Si no hay documento o campo nombre, usa el email como fallback
          setState(() {
            _nombreUsuario = user.email ?? 'Usuario Anónimo';
          });
        }
      }
    } else {
      setState(() {
        _nombreUsuario = 'Usuario Desconocido';
      });
    }
  }

  // Seleccionar fecha y hora
  Future<void> _seleccionarFechaYHora() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ), // Permite seleccionar fechas pasadas recientes
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && mounted) {
      // Check if mounted
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _fechaSeleccionada ?? DateTime.now(),
        ),
      );

      if (pickedTime != null) {
        setState(() {
          _fechaSeleccionada = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Agregar o actualizar cita
  Future<void> _guardarCita() async {
    if (_motivoController.text.isEmpty || _fechaSeleccionada == null) {
      if (mounted) {
        // Check if mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Completa todos los campos")),
        );
      }
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        // Check if mounted
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Usuario no autenticado")));
      }
      return;
    }

    final data = {
      'userId': user.uid, // Guardar el UID del usuario que crea la cita
      'nombreUsuario': _nombreUsuario ?? 'Sin nombre',
      'motivo': _motivoController.text.trim(),
      'fechaHora': Timestamp.fromDate(_fechaSeleccionada!),
      'creadoEn': FieldValue.serverTimestamp(),
    };

    try {
      if (_citaEnEdicionId == null) {
        // Crear nueva cita
        await _firestore.collection('citas').add(data);
        if (mounted) {
          // Check if mounted
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Cita creada")));
        }
      } else {
        // Actualizar cita existente
        await _firestore.collection('citas').doc(_citaEnEdicionId).update(data);
        if (mounted) {
          // Check if mounted
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Cita actualizada")));
        }
      }

      // Limpiar formulario después de guardar
      _motivoController.clear();
      setState(() {
        _fechaSeleccionada = null;
        _citaEnEdicionId = null;
      });
    } catch (e) {
      if (mounted) {
        // Check if mounted
        print("Error al guardar cita: $e"); // Imprime el error en la consola
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la cita: ${e.toString()}")),
        );
      }
    }
  }

  // Eliminar cita
  Future<void> _eliminarCita(String id) async {
    try {
      await _firestore.collection('citas').doc(id).delete();
      if (mounted) {
        // Check if mounted
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Cita eliminada")));
      }
    } catch (e) {
      if (mounted) {
        // Check if mounted
        print("Error al eliminar cita: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar la cita: ${e.toString()}")),
        );
      }
    }
  }

  // Preparar cita para edición
  void _editarCita(String id, Map<String, dynamic> data) {
    setState(() {
      _citaEnEdicionId = id;
      _motivoController.text = data['motivo'] ?? '';
      _fechaSeleccionada = (data['fechaHora'] as Timestamp?)?.toDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el UID del usuario actual para filtrar las citas
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Citas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _nombreUsuario == null
                  ? 'Cargando usuario...'
                  : 'Usuario: $_nombreUsuario',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo de la cita',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaSeleccionada == null
                        ? 'No se ha seleccionado fecha y hora'
                        : 'Fecha: ${_fechaSeleccionada?.toLocal().toString().substring(0, 16)}',
                  ), // Formato legible
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _seleccionarFechaYHora,
                ),
              ],
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _guardarCita,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Programar Cita',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mis Citas Programadas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Filtrar citas por el userId del usuario actual
                stream: _firestore
                    .collection('citas')
                    .where('userId', isEqualTo: currentUserId) // Filtro
                    .orderBy('fechaHora', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.hasError) {
                    print("Error en StreamBuilder: ${snapshot.error}");
                    return Center(
                      child: Text('Error al cargar citas: ${snapshot.error}'),
                    );
                  }

                  final citas = snapshot.data!.docs;
                  if (citas.isEmpty) {
                    return const Center(
                      child: Text('No tienes citas programadas.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: citas.length,
                    itemBuilder: (context, index) {
                      final cita = citas[index];
                      // Asegurarse de que data no sea null
                      final data = cita.data() as Map<String, dynamic>? ?? {};
                      final fecha = (data['fechaHora'] as Timestamp?)?.toDate();
                      final motivo = data['motivo'] ?? 'Sin motivo';
                      final nombreCita = data['nombreUsuario'] ?? 'Desconocido';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text('$motivo ($nombreCita)'),
                          subtitle: Text(
                            fecha != null
                                ? 'Fecha: ${fecha.toLocal().toString().substring(0, 16)}'
                                : 'Sin fecha',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _editarCita(cita.id, data),
                                tooltip: 'Editar Cita',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _eliminarCita(cita.id),
                                tooltip: 'Eliminar Cita',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
