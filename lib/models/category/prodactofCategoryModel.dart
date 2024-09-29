class prodactofCategory {
  int? id;
  String? name;
  String? image;

  prodactofCategory({this.id, this.name, this.image});

  factory prodactofCategory.fromJson(Map<String, dynamic> json) =>
      prodactofCategory(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
