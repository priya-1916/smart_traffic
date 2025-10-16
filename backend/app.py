from flask import Flask, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import time

app = Flask(__name__)
CORS(app)

# Wait for MongoDB to start
time.sleep(5)

# Connect to MongoDB
client = MongoClient("mongodb://localhost:27017/")
db = client.traffic_db
collection = db.traffic

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

# Insert data only if collection is empty
if collection.count_documents({}) == 0:
    collection.insert_many(traffic_data)

@app.route('/api/traffic', methods=['GET'])
def get_traffic():
    return jsonify(list(collection.find({}, {"_id": 0})))

@app.route('/', methods=['GET'])
def home():
    return jsonify({"status":"online","message":"Traffic API running"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True,use_reloader=False)