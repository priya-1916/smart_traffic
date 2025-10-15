// lib/screens/traffic_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TrafficScreen extends StatefulWidget {
  @override
  _TrafficScreenState createState() => _TrafficScreenState();
}

class _TrafficScreenState extends State<TrafficScreen> {
  List<dynamic> roads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTraffic();
  }

  fetchTraffic() async {
    setState(() => isLoading = true);
    var data = await ApiService.fetchTraffic();
    setState(() {
      roads = data;
      isLoading = false;
    });
  }

  Color getColor(String congestion) {
    switch (congestion) {
      case "High": return Colors.red;
      case "Medium": return Colors.orange;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => fetchTraffic(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Live Traffic Status',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (isLoading)
            SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (roads.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text('No data available')),
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
                        backgroundColor: getColor(road['congestion']).withOpacity(0.2),
                        child: Icon(Icons.traffic, color: getColor(road['congestion'])),
                      ),
                      title: Text(road['road'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vehicles: ${road['vehicle_count']}'),
                          Text('${road['congestion']} congestion'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
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