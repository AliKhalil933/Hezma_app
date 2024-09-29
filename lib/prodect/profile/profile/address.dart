class Address {
  int? id;
  String? name;
  String? lat;
  String? lng;
  String? address;
  String? distance;

  Address({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.address,
    this.distance,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as int?,
        name: json['name'] as String?,
        lat: json['lat'] as String?,
        lng: json['lng'] as String?,
        address: json['address'] as String?,
        distance: json['distance'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'address': address,
        'distance': distance,
      };
}
