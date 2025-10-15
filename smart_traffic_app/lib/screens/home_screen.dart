// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_manager.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF238636), Color(0xFF1A5F2A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.security, size: 64, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'SafeRoute Pro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Stay Safe on the Road',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Feature Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: Icons.traffic,
                      title: 'Traffic',
                      subtitle: 'Live Status',
                      color: Colors.orange,
                      onTap: () => _navigate(context, 1),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.local_hospital,
                      title: 'Emergency',
                      subtitle: 'Fast Routes',
                      color: Colors.red,
                      onTap: () => _navigate(context, 2),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.umbrella,
                      title: 'Rain Alerts',
                      subtitle: 'Weather Updates',
                      color: Colors.blue,
                      onTap: () => _navigate(context, 3), // Note: This is now Map, but kept as example; adjust if needed
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.map,
                      title: 'Live Map',
                      subtitle: 'Interactive View',
                      color: Colors.purple,
                      onTap: () => _showMapSuggestion(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              SizedBox(height: 12),
              Text(title, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 4),
              Text(subtitle, 
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    // Handled by MainScreen
  }

  void _showMapSuggestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🚀 Live Map Feature'),
        content: Text(
          'Add Google Maps integration for:\n'
          '• Real-time traffic visualization\n'
          '• Route optimization\n'
          '• Emergency path highlighting\n\n'
          'Would you like implementation guide?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMapImplementation(context);
            },
            child: Text('Show Guide'),
          ),
        ],
      ),
    );
  }

  void _showMapImplementation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🗺️ Map Integration Guide'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Add to pubspec.yaml:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text('google_maps_flutter: ^2.5.0'),
              ),
              SizedBox(height: 16),
              Text('2. Get API Key: console.cloud.google.com'),
              Text('3. Create MapScreen.dart'),
              Text('4. Add markers for traffic/emergency'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!'),
          ),
        ],
      ),
    );
  }
}