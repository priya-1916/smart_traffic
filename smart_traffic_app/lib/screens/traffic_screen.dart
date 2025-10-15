import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TrafficScreen extends StatefulWidget {
  @override
  _TrafficScreenState createState() => _TrafficScreenState();
}

class _TrafficScreenState extends State<TrafficScreen> {
  List<dynamic> roads = [];

  @override
  void initState() {
    super.initState();
    fetchTraffic();
  }

  fetchTraffic() async {
    var data = await ApiService.fetchTraffic();
    setState(() {
      roads = data;
    });
  }

  Color getColor(String congestion) {
    switch (congestion) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Traffic Status")),
      body: roads.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: roads.length,
              itemBuilder: (context, index) {
                var road = roads[index];
                return Card(
                  child: ListTile(
                    title: Text(road['road']),
                    subtitle: Text("Vehicles: ${road['vehicle_count']}"),
                    trailing: Icon(Icons.circle,
                        color: getColor(road['congestion'])),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: fetchTraffic,
      ),
    );
  }
}
