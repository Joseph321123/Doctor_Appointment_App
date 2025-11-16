import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CitasStatsChart extends StatefulWidget {
  const CitasStatsChart({super.key});

  @override
  State<CitasStatsChart> createState() => _CitasStatsChartState();
}

class _CitasStatsChartState extends State<CitasStatsChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Guardamos el conteo de citas por día
  Map<String, int> citasPorDia = {};

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  Future<void> _loadCitas() async {
    final snapshot = await _firestore.collection('citas').get();

    final Map<String, int> temp = {};

    for (var doc in snapshot.docs) {
      final Timestamp fechaHora = doc['fechaHora'];
      final dateStr = DateFormat('dd/MM').format(fechaHora.toDate());

      temp[dateStr] = (temp[dateStr] ?? 0) + 1;
    }

    setState(() {
      citasPorDia = Map.fromEntries(
        temp.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (citasPorDia.isEmpty) {
      return const Center(child: Text('No hay citas registradas'));
    }

    final List<BarChartGroupData> barGroups = [];
    int x = 0;
    citasPorDia.forEach((date, count) {
      barGroups.add(
        BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      x++;
    });

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              (citasPorDia.values.reduce((a, b) => a > b ? a : b)).toDouble() +
              1,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < citasPorDia.keys.length) {
                    return Text(citasPorDia.keys.elementAt(index));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
