// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    setState(() => isLoading = true);

    // Traffic data with precise coordinates for Coimbatore
    final trafficData = [
      {"road": "Avinashi Road", "lat": 11.024487, "lng": 77.007567, "vehicle_count": 85, "congestion": "High"},
      {"road": "Trichy Road", "lat": 11.010000, "lng": 76.974000, "vehicle_count": 60, "congestion": "Medium"},
      {"road": "Mettupalayam Road", "lat": 11.041000, "lng": 76.955000, "vehicle_count": 30, "congestion": "Low"},
      {"road": "Peelamedu / ESI Road", "lat": 11.020000, "lng": 76.975000, "vehicle_count": 25, "congestion": "Low"},
      {"road": "Race Course Road", "lat": 11.010500, "lng": 76.970000, "vehicle_count": 55, "congestion": "Medium"},
      {"road": "Singanallur Road", "lat": 10.998000, "lng": 77.015000, "vehicle_count": 45, "congestion": "Medium"},
      {"road": "Thadagam Road", "lat": 11.035000, "lng": 76.990000, "vehicle_count": 15, "congestion": "Low"},
      {"road": "Gandhipuram", "lat": 11.016500, "lng": 76.955000, "vehicle_count": 90, "congestion": "High"},
      {"road": "Saravanampatti Road", "lat": 11.030000, "lng": 76.990000, "vehicle_count": 50, "congestion": "Medium"},
      {"road": "Ukkadam / Podanur Road", "lat": 10.996500, "lng": 76.960000, "vehicle_count": 70, "congestion": "High"},
    ];

    setState(() {
      _markers = trafficData.map<Marker>((road) {
        final position = LatLng(road['lat'] as double, road['lng'] as double);
        Color color = _getMarkerColor(road['congestion'] as String);
        return Marker(
          point: position,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showRoadInfo(road),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_pin, color: Colors.white, size: 20),
            ),
          ),
        );
      }).toList();
      isLoading = false;
    });
  }

  Color _getMarkerColor(String congestion) {
    switch (congestion) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _showRoadInfo(Map<String, dynamic> road) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(road['road']),
        content: Text('${road['congestion']} congestion • ${road['vehicle_count']} vehicles'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    final center = _mapController.camera.center;
    final zoom = _mapController.camera.zoom;
    if (zoom < 18) _mapController.move(center, zoom + 1);
  }

  void _zoomOut() {
    final center = _mapController.camera.center;
    final zoom = _mapController.camera.zoom;
    if (zoom > 1) _mapController.move(center, zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(11.0168, 76.9558),
                initialZoom: 12.0,
                minZoom: 1.0,
                maxZoom: 18.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                // OpenStreetMap Tiles
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          // Top Controls: Center Map Button
          Positioned(
            top: 50,
            left: 16,
            child: FloatingActionButton(
              heroTag: "center",
              mini: true,
              onPressed: () => _mapController.move(const LatLng(11.0168, 76.9558), 12.0),
              child: const Icon(Icons.my_location),
            ),
          ),
          // Zoom Controls
          Positioned(
            bottom: 50,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  mini: true,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // Refresh button at bottom-left
          Positioned(
            bottom: 50,
            left: 16,
            child: FloatingActionButton(
              heroTag: "refresh",
              onPressed: _loadMapData,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
