import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<dynamic> roads = [];

  @override
  void initState() {
    super.initState();
    fetchEmergencyRoutes();
  }

  fetchEmergencyRoutes() async {
    var data = await ApiService.fetchTraffic();
    setState(() {
      roads = data.where((r) => r['congestion'] == 'Low').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Routes")),
      body: roads.isEmpty
          ? Center(child: Text("No low congestion routes available"))
          : ListView.builder(
              itemCount: roads.length,
              itemBuilder: (context, index) {
                var road = roads[index];
                return Card(
                  child: ListTile(
                    title: Text(road['road']),
                    subtitle: Text("Vehicles: ${road['vehicle_count']}"),
                    trailing: Icon(Icons.local_hospital, color: Colors.blue),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: fetchEmergencyRoutes,
      ),
    );
  }
}
