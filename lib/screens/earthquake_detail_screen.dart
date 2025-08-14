import 'package:flutter/material.dart';
import 'package:jishin/models/earthquake.dart';

class EarthquakeDetailScreen extends StatelessWidget {
  final Earthquake earthquake;

  const EarthquakeDetailScreen({super.key, required this.earthquake});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地震詳細'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '発生日時: ${earthquake.time.toLocal().year}/${earthquake.time.toLocal().month}/${earthquake.time.toLocal().day} ${earthquake.time.toLocal().hour}:${earthquake.time.toLocal().minute}:${earthquake.time.toLocal().second}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '震源: ${earthquake.region}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'マグニチュード: ${earthquake.magnitude.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '深さ: ${earthquake.depth}km',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (earthquake.tsunamiWarning.isNotEmpty)
              Text(
                '津波情報: ${earthquake.tsunamiWarning}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            // Add more details here if available in Earthquake model
          ],
        ),
      ),
    );
  }
}