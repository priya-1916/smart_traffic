// lib/screens/emergency_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'map_screen.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<dynamic> roads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmergencyRoutes();
  }

  fetchEmergencyRoutes() async {
    setState(() => isLoading = true);
    var data = await ApiService.fetchTraffic();
    setState(() {
      roads = data.where((r) => r['congestion'] == 'Low').toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => fetchEmergencyRoutes(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Emergency Routes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (isLoading)
            SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (roads.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text('No low congestion routes available')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var road = roads[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        child: Icon(Icons.local_hospital, color: Colors.red),
                      ),
                      title: Text(road['road'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Vehicles: ${road['vehicle_count']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_hospital, color: Colors.red),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.map, size: 20),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MapScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: roads.length,
              ),
            ),
        ],
      ),
    );
  }
}