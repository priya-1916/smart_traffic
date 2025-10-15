import 'package:flutter/material.dart';
import 'traffic_screen.dart';
import 'emergency_screen.dart';
import 'rain_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SafeRoute Mini')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('View Traffic Status'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TrafficScreen()));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Emergency Route'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EmergencyScreen()));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Rain Alerts'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RainScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
