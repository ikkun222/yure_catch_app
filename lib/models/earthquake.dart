import 'package:intl/intl.dart'; // Add this import

class Earthquake {
  final DateTime time;
  final String region;
  final double magnitude;
  final double depth;
  final String tsunamiWarning; // 津波情報
  final double latitude; // Add latitude
  final double longitude; // Add longitude

  Earthquake({
    required this.time,
    required this.region,
    required this.magnitude,
    required this.depth,
    required this.tsunamiWarning,
    required this.latitude, // Add to constructor
    required this.longitude, // Add to constructor
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final earthquakeData = json['earthquake'];
    final hypocenterData = earthquakeData['hypocenter'];

    // Parse magnitude string to double
    double magnitude = 0.0;
    if (hypocenterData['magnitude'] != null) {
      magnitude = double.parse(hypocenterData['magnitude'].toString());
    }

    // Parse depth string to double, removing "km"
    double depth = 0.0;
    if (hypocenterData['depth'] != null && hypocenterData['depth'].toString().contains('km')) {
      depth = double.parse(hypocenterData['depth'].toString().replaceAll('km', ''));
    } else if (hypocenterData['depth'] != null) {
      // Handle cases where 'km' might be missing or depth is just a number
      depth = double.parse(hypocenterData['depth'].toString());
    }

    // Parse latitude and longitude
    double latitude = 0.0;
    if (hypocenterData['latitude'] != null) {
      // Remove 'N' or 'S' and parse
      latitude = double.parse(hypocenterData['latitude'].toString().replaceAll(RegExp(r'[NS]'), ''));
      if (hypocenterData['latitude'].toString().startsWith('S')) {
        latitude *= -1; // Southern hemisphere
      }
    }

    double longitude = 0.0;
    if (hypocenterData['longitude'] != null) {
      // Remove 'E' or 'W' and parse
      longitude = double.parse(hypocenterData['longitude'].toString().replaceAll(RegExp(r'[EW]'), ''));
      if (hypocenterData['longitude'].toString().startsWith('W')) {
        longitude *= -1; // Western hemisphere
      }
    }


    return Earthquake(
      time: DateFormat("yyyy/MM/dd HH:mm:ss.SSS").parse(json['time'] as String),
      region: hypocenterData['name'] as String,
      magnitude: magnitude,
      depth: depth,
      tsunamiWarning: earthquakeData['domesticTsunami'] as String,
      latitude: latitude,
      longitude: longitude,
    );
  }
}