class Detail {
  final String name;
  final String price;
  final String mainSectorId;
  final String sectorTypeId;

  Detail({
    required this.name,
    required this.price,
    required this.mainSectorId,
    required this.sectorTypeId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      name: json['name'],
      price: json['price'],
      mainSectorId: json['main_sector_id'],
      sectorTypeId: json['sector_type_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'main_sector_id': mainSectorId,
        'sector_type_id': sectorTypeId,
      };
}
