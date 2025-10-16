import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_manager.dart';
import 'map_screen.dart';
import 'traffic_screen.dart';
import 'emergency_screen.dart';
import 'rain_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32), // Removed logo

            // Feature Cards Grid
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
                    page:  TrafficScreen(),
                    themeManager: themeManager,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.local_hospital,
                    title: 'Emergency',
                    subtitle: 'Fast Routes',
                    color: Colors.red,
                    page: EmergencyScreen(),
                    themeManager: themeManager,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.umbrella,
                    title: 'Rain Alerts',
                    subtitle: 'Weather Updates',
                    color: Colors.blue,
                    page: RainScreen(),
                    themeManager: themeManager,
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.map,
                    title: 'Live Map',
                    subtitle: 'Interactive View',
                    color: Colors.purple,
                    page: const MapScreen(),
                    themeManager: themeManager,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
    required ThemeManager themeManager,
  }) {
    final cardTheme = Theme.of(context).cardTheme;

    return Card(
      color: cardTheme.color,
      elevation: cardTheme.elevation,
      shape: cardTheme.shape,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // ✅ Wrap with ChangeNotifierProvider.value to pass the same ThemeManager
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: themeManager,
                child: page,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
