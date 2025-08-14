
import 'package:flutter/material.dart';
import 'package:jishin/models/earthquake.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailScreen extends StatelessWidget {
  final Earthquake earthquake;

  const DetailScreen({super.key, required this.earthquake});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地震詳細'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '発生日時: ${earthquake.time.toLocal().year}/${earthquake.time.toLocal().month}/${earthquake.time.toLocal().day} ${earthquake.time.toLocal().hour}:${earthquake.time.toLocal().minute}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '震源: ${earthquake.region}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'マグニチュード: ${earthquake.magnitude.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '深さ: ${earthquake.depth}km',
                  style: const TextStyle(fontSize: 18),
                ),
                if (earthquake.tsunamiWarning.isNotEmpty)
                  Text(
                    '津波情報: ${earthquake.tsunamiWarning}',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(earthquake.latitude, earthquake.longitude),
                initialZoom: 8.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app', // Replace with your package name
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(earthquake.latitude, earthquake.longitude),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
