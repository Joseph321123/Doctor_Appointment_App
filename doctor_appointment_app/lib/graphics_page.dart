// graphics_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraphicsPage extends StatefulWidget {
  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gráficas de Citas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Cantidad de citas por mes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildBarChart(),
              const SizedBox(height: 32),
              const Text(
                "Citas por paciente",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  // GRÁFICA DE BARRAS
  Widget _buildBarChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('citas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Contar citas por mes/año
        Map<String, int> citasPorMes = {};

        for (var doc in snapshot.data!.docs) {
          final timestamp = doc['creadoEn'] as Timestamp?;
          if (timestamp == null) continue;
          final date = timestamp.toDate();
          final mesAnio = DateFormat('MMM yyyy').format(date);

          if (citasPorMes.containsKey(mesAnio)) {
            citasPorMes[mesAnio] = citasPorMes[mesAnio]! + 1;
          } else {
            citasPorMes[mesAnio] = 1;
          }
        }

        final mesKeys = citasPorMes.keys.toList();
        final barGroups = <BarChartGroupData>[];

        for (int i = 0; i < mesKeys.length; i++) {
          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: citasPorMes[mesKeys[i]]!.toDouble(),
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (citasPorMes.values.isEmpty)
                  ? 5
                  : (citasPorMes.values.reduce((a, b) => a > b ? a : b) + 2)
                        .toDouble(),
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString());
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= mesKeys.length)
                        return const Text('');
                      return Text(
                        mesKeys[index],
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }

  // GRÁFICA DE PASTEL
  Widget _buildPieChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('citas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return FutureBuilder<List<String>>(
          future: Future.wait(
            docs.map((doc) async {
              String nombre = doc['nombreUsuario'] ?? '';

              // Si nombreUsuario está vacío, buscamos en la colección usuarios
              if (nombre.isEmpty && doc['userId'] != null) {
                final userDoc = await _firestore
                    .collection('usuarios')
                    .doc(doc['userId'])
                    .get();
                nombre = userDoc.data()?['nombre'] ?? 'Sin nombre';
              }

              return nombre;
            }).toList(),
          ),
          builder: (context, snapshotNombres) {
            if (!snapshotNombres.hasData)
              return const Center(child: CircularProgressIndicator());

            Map<String, int> citasPorPaciente = {};
            final nombres = snapshotNombres.data!;

            for (var nombre in nombres) {
              if (citasPorPaciente.containsKey(nombre)) {
                citasPorPaciente[nombre] = citasPorPaciente[nombre]! + 1;
              } else {
                citasPorPaciente[nombre] = 1;
              }
            }

            final colors = [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.brown,
              Colors.cyan,
              Colors.pink,
              Colors.teal,
              Colors.indigo,
            ];

            int colorIndex = 0;
            final sections = <PieChartSectionData>[];

            citasPorPaciente.forEach((nombre, count) {
              sections.add(
                PieChartSectionData(
                  value: count.toDouble(),
                  title: nombre,
                  color: colors[colorIndex % colors.length],
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
              colorIndex++;
            });

            return SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
