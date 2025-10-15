from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app to communicate

# Traffic data
traffic_data = [
    {"road": "Avinashi Road", "vehicle_count": 85, "congestion": "High", "rain": False, "emergency": False},
    {"road": "Trichy Road", "vehicle_count": 60, "congestion": "Medium", "rain": True, "emergency": False},
    {"road": "Mettupalayam Road", "vehicle_count": 30, "congestion": "Low", "rain": False, "emergency": True},
    {"road": "Peelamedu / ESI Road", "vehicle_count": 25, "congestion": "Low", "rain": True, "emergency": False},
    {"road": "Race Course Road", "vehicle_count": 55, "congestion": "Medium", "rain": False, "emergency": False},
    {"road": "Singanallur Road", "vehicle_count": 45, "congestion": "Medium", "rain": False, "emergency": False},
    {"road": "Thadagam Road", "vehicle_count": 15, "congestion": "Low", "rain": False, "emergency": False},
    {"road": "Gandhipuram", "vehicle_count": 90, "congestion": "High", "rain": False, "emergency": False},
    {"road": "Saravanampatti Road", "vehicle_count": 50, "congestion": "Medium", "rain": True, "emergency": False},
    {"road": "Ukkadam / Podanur Road", "vehicle_count": 70, "congestion": "High", "rain": False, "emergency": False}
]

@app.route('/api/traffic', methods=['GET'])
def get_traffic():
    """Return all traffic data"""
    return jsonify(traffic_data)

@app.route('/api/traffic/emergency', methods=['GET'])
def get_emergency_routes():
    """Return only low congestion routes for emergency vehicles"""
    emergency_routes = [road for road in traffic_data if road['congestion'] == 'Low']
    return jsonify(emergency_routes)

@app.route('/api/traffic/rain', methods=['GET'])
def get_rain_alerts():
    """Return roads with rain alerts"""
    rain_roads = [road for road in traffic_data if road['rain'] == True]
    return jsonify(rain_roads)

@app.route('/api/traffic/high', methods=['GET'])
def get_high_congestion():
    """Return roads with high congestion"""
    high_congestion = [road for road in traffic_data if road['congestion'] == 'High']
    return jsonify(high_congestion)

@app.route('/', methods=['GET'])
def home():
    """API health check"""
    return jsonify({
        "status": "online",
        "message": "Traffic Management API is running",
        "endpoints": [
            "/api/traffic",
            "/api/traffic/emergency",
            "/api/traffic/rain",
            "/api/traffic/high"
        ]
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)