import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers

class ShakeTestScreen extends StatefulWidget {
  const ShakeTestScreen({super.key});

  @override
  State<ShakeTestScreen> createState() => _ShakeTestScreenState();
}

class _ShakeTestScreenState extends State<ShakeTestScreen> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _maxAcceleration = 0.0;
  String _seismicIntensityEstimate = "測定を開始してください"; // Polite language
  bool _isMeasuring = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create AudioPlayer instance

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  void _startMeasurement() {
    setState(() {
      _isMeasuring = true;
      _maxAcceleration = 0.0;
      _seismicIntensityEstimate = "揺れを測定中です..."; // Polite language
    });

    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: const Duration(milliseconds: 100)).listen((event) {
      final double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      print('Accelerometer: x=${event.x.toStringAsFixed(2)}, y=${event.y.toStringAsFixed(2)}, z=${event.z.toStringAsFixed(2)}, acc=${acceleration.toStringAsFixed(2)}'); // Debug print
      if (acceleration > _maxAcceleration) {
        _maxAcceleration = acceleration;
        _updateSeismicIntensityEstimate();
      }
    });
  }

  void _stopMeasurement() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    setState(() {
      _isMeasuring = false;
      _seismicIntensityEstimate = "測定が終了いたしました"; // Polite language
    });
  }

  void _updateSeismicIntensityEstimate() {
    String estimate;
    String audioFileName = "";
    // Adjusted thresholds to account for gravity (approx 9.81 m/s^2)
    // These thresholds are relative to the total acceleration, including gravity.
    if (_maxAcceleration < 9.81 + 0.5) { // Very slight movement above gravity
      estimate = "震度1程度 (わずかな揺れ)"; // Polite language
      audioFileName = "sin1.mp3";
    } else if (_maxAcceleration < 9.81 + 2.0) { // Small movement above gravity
      estimate = "震度2程度 (少しの揺れ)"; // Polite language
      audioFileName = "sin2.mp3";
    } else if (_maxAcceleration < 9.81 + 5.0) { // Moderate movement above gravity
      estimate = "震度3程度 (やや強い揺れ)"; // Polite language
      audioFileName = "sin3.mp3";
    } else if (_maxAcceleration < 9.81 + 10.0) { // Strong movement above gravity
      estimate = "震度4程度 (強い揺れ)"; // Polite language
      audioFileName = "sin4.mp3";
    } else { // Very strong movement above gravity
      estimate = "震度5弱以上 (非常に強い揺れ)"; // Polite language
      audioFileName = "sin5.mp3";
    }

    setState(() {
      _seismicIntensityEstimate = estimate;
    });

    if (audioFileName.isNotEmpty) {
      _audioPlayer.play(AssetSource(audioFileName)); // Play audio from assets
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('揺れ測定'), // Polite language
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '現在の最大加速度: ${_maxAcceleration.toStringAsFixed(2)} m/s²', // Polite language
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                '推定震度: $_seismicIntensityEstimate', // Polite language
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _isMeasuring
                  ? ElevatedButton.icon(
                      onPressed: _stopMeasurement,
                      icon: const Icon(Icons.stop),
                      label: const Text('測定を停止する'), // Polite language
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _startMeasurement,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('測定を開始する'), // Polite language
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                '※この機能はあくまで目安であり、実際の震度とは異なります。', // Polite language
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}