import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your Flask backend URL
  // For Android Emulator use: http://10.0.2.2:5000/api
  // For iOS Simulator use: http://127.0.0.1:5000/api
  // For Physical Device use: http://YOUR_COMPUTER_IP:5000/api
  static const String baseUrl = "http://127.0.0.1:5000/api";
  
  // Fetch all traffic data
  static Future<List<dynamic>> fetchTraffic() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/traffic'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to fetch traffic data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching traffic: $e");
      rethrow;
    }
  }
  
  // Fetch emergency routes (low congestion)
  static Future<List<dynamic>> fetchEmergencyRoutes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/traffic/emergency'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to fetch emergency routes: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching emergency routes: $e");
      rethrow;
    }
  }
  
  // Fetch rain alerts
  static Future<List<dynamic>> fetchRainAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/traffic/rain'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to fetch rain alerts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching rain alerts: $e");
      rethrow;
    }
  }
}