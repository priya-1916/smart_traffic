// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';
import 'screens/home_screen.dart';
import 'screens/traffic_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: 'SafeRoute Pro',
          theme: themeManager.currentTheme,
          home: MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    TrafficScreen(),
    EmergencyScreen(),
    MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: Color(0xFF238636),
            unselectedItemColor: Colors.grey,
            backgroundColor: themeManager.isDarkMode 
                ? Color(0xFF21262D) 
                : Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.traffic), label: 'Traffic'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital), label: 'Emergency'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            ],
          ),
          appBar: AppBar(
            title: Text(['Home', 'Traffic', 'Emergency', 'Map']
                [_currentIndex]),
            actions: [
              Consumer<ThemeManager>(
                builder: (context, themeManager, child) {
                  return IconButton(
                    icon: Icon(themeManager.isDarkMode 
                        ? Icons.light_mode 
                        : Icons.dark_mode),
                    onPressed: themeManager.toggleTheme,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}