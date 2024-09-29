class SliderModel {
  final int id;
  final String name;
  final String title;
  final String image;

  SliderModel({
    required this.id,
    required this.name,
    required this.title,
    required this.image,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'image': image,
    };
  }
}
