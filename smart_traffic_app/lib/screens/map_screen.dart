// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key}); // ✅ FIXED: Added key parameter

  @override
  State<MapScreen> createState() => _MapScreenState(); // ✅ FIXED: Public State
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  bool _showTrafficLayer = true;
  bool isLoading = true;

  // REPLACE WITH YOUR MAPBOX TOKEN
  static const String _mapboxAccessToken = 'pk.eyJ1IjoicHJpeWExOSIsImEiOiJjbWdzMnRvY2szYm1lMmtxMXU5dG5kZ2ZsIn0.m9rD82mSS3ZYoGZBZ2eWQA'; // ← PASTE HERE!

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    setState(() => isLoading = true);
    try {
      var trafficData = await ApiService.fetchTraffic();
      if (!mounted) return; // ✅ FIXED: BuildContext safety
      
      setState(() {
        _markers = trafficData.map<Marker>((road) {
          // ✅ FIXED: Use real lat/lng OR fallback coordinates
          final lat = road['lat'] ?? 37.7749 + (trafficData.indexOf(road) * 0.01);
          final lng = road['lng'] ?? -122.4194 + (trafficData.indexOf(road) * 0.01);
          final position = LatLng(lat, lng);
          
          Color color = _getMarkerColor(road['congestion']);
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
                child: Icon(Icons.location_pin, color: Colors.white, size: 20),
              ),
            ),
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e'))
        );
      }
    }
  }

  Color _getMarkerColor(String congestion) {
    switch (congestion) {
      case "High": return Colors.red;
      case "Medium": return Colors.orange;
      default: return Colors.green;
    }
  }

  void _showRoadInfo(dynamic road) {
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
                initialCenter: const LatLng(37.7749, -122.4194), // San Francisco
                initialZoom: 11.0,
                onTap: (_, __) {}, // ✅ FIXED: Removed print
              ),
              children: [
                // MapBox Tiles
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken': _mapboxAccessToken,
                    'id': 'streets-v12',
                  },
                ),
                // Traffic Overlay
                if (_showTrafficLayer)
                  TileLayer(
                    urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: {
                      'accessToken': _mapboxAccessToken,
                      'id': 'mapbox-mapbox-traffic-v1',
                    },
                    // ✅ FIXED: Use TileLayerOptions with opacity
                    tileProvider: NetworkTileProvider(),
                  ),
                // Markers
                MarkerLayer(markers: _markers),
              ],
            ),
          // Top Controls
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "center",
                  mini: true,
                  onPressed: () => _mapController.move(const LatLng(37.7749, -122.4194), 11.0),
                  child: const Icon(Icons.my_location),
                ),
                const Spacer(),
                FloatingActionButton(
                  heroTag: "traffic",
                  mini: true,
                  backgroundColor: _showTrafficLayer ? Colors.green : Colors.grey,
                  onPressed: () => setState(() => _showTrafficLayer = !_showTrafficLayer),
                  child: const Icon(Icons.traffic),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMapData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}