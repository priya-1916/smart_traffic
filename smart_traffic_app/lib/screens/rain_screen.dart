import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RainScreen extends StatefulWidget {
  @override
  _RainScreenState createState() => _RainScreenState();
}

class _RainScreenState extends State<RainScreen> {
  List<dynamic> roads = [];

  @override
  void initState() {
    super.initState();
    fetchRainRoads();
  }

  fetchRainRoads() async {
    var data = await ApiService.fetchTraffic();
    setState(() {
      roads = data.where((r) => r['rain'] == true).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rain Alerts")),
      body: roads.isEmpty
          ? Center(child: Text("No rain alerts"))
          : ListView.builder(
              itemCount: roads.length,
              itemBuilder: (context, index) {
                var road = roads[index];
                return Card(
                  child: ListTile(
                    title: Text(road['road']),
                    subtitle: Text("Rain detected! Drive carefully"),
                    trailing: Icon(Icons.umbrella, color: Colors.blue),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: fetchRainRoads,
      ),
    );
  }
}
