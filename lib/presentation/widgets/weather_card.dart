import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double temperature;
  final String status;

  WeatherCard({required this.temperature, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Suhu di Lampung:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$temperature°C',
              style: TextStyle(fontSize: 40),
            ),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
