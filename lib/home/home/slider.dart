class SliderModel {
  int? id;
  String? name;
  String? title;
  String? image;

  SliderModel({this.id, this.name, this.title, this.image});

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        title: json['title'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'image': image,
      };
}
