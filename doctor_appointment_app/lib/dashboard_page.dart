// dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa estadísticas
import 'citas_stats_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserRole() async {
    final uid = _auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();
    return doc['rol'] ?? 'Paciente';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data!;

        if (role != 'Médico') {
          return const Scaffold(
            body: Center(child: Text('No tienes permiso para ver esta página')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard Médico')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Asegura scroll si el contenido es largo
              child: Column(
                children: [
                  // Indicadores existentes
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('citas')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      final totalCitas = snapshot.data!.docs.length;
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          title: const Text('Total de citas'),
                          trailing: Text(totalCitas.toString()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('citas')
                        .where('estado', isEqualTo: 'pendiente')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      final citasPendientes = snapshot.data!.docs.length;
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.pending_actions,
                            color: Colors.orange,
                          ),
                          title: const Text('Citas pendientes'),
                          trailing: Text(citasPendientes.toString()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .where('rol', isEqualTo: 'Paciente')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      final totalPacientes = snapshot.data!.docs.length;
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                          title: const Text('Total de pacientes'),
                          trailing: Text(totalPacientes.toString()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // gráfico
                  const CitasStatsChart(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
