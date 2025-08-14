
import 'package:flutter/material.dart';
import 'package:jishin/models/earthquake.dart';
import 'package:jishin/services/earthquake_service.dart';
import 'package:jishin/screens/detail_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:jishin/screens/shake_test_screen.dart'; // Import ShakeTestScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Earthquake>> _earthquakes;
  DateTime? _lastCheckedTime;

  @override
  void initState() {
    super.initState();
    _fetchEarthquakes();
  }

  Future<void> _fetchEarthquakes() async {
    setState(() {
      _earthquakes = EarthquakeService().fetchLatestEarthquakes();
      _lastCheckedTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ゆれキャッチ'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchEarthquakes();
              Workmanager().registerOneOffTask(
                "manualFetchEarthquakeTask",
                "fetchEarthquakeTask",
                initialDelay: Duration.zero,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_lastCheckedTime != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '最終チェック: ${_lastCheckedTime!.toLocal().hour}:${_lastCheckedTime!.toLocal().minute}:${_lastCheckedTime!.toLocal().second}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Earthquake>>(
              future: _earthquakes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('エラー: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('地震情報がありません。'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final earthquake = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(earthquake: earthquake),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${earthquake.time.toLocal().year}/${earthquake.time.toLocal().month}/${earthquake.time.toLocal().day} ${earthquake.time.toLocal().hour}:${earthquake.time.toLocal().minute}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  '震源: ${earthquake.region}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'マグニチュード: ${earthquake.magnitude.toStringAsFixed(1)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '深さ: ${earthquake.depth}km',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (earthquake.tsunamiWarning.isNotEmpty)
                                  Text(
                                    '津波情報: ${earthquake.tsunamiWarning}',
                                    style: const TextStyle(fontSize: 16, color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended( // Add FloatingActionButton
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShakeTestScreen()),
          );
        },
        label: const Text('揺れを測定する'), // Polite language
        icon: const Icon(Icons.sensors),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
