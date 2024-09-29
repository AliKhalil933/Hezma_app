class modelOfDistractis {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double distance;

  modelOfDistractis({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory modelOfDistractis.fromJson(Map<String, dynamic> json) {
    return modelOfDistractis(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: double.parse(json['distance']),
    );
  }
}
