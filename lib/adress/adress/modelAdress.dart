class modelofAdress {
  final int id;
  final String name;
  final String lat;
  final String lng;
  final String address;
  final String distance;

  modelofAdress({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    required this.distance,
  });

  factory modelofAdress.fromJson(Map<String, dynamic> json) {
    return modelofAdress(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      address: json['address'] as String,
      distance: json['distance'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'address': address,
        'distance': distance,
      };

  copyWith({required String name, required String address}) {}
}
