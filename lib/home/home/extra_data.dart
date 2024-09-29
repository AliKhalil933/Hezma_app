import 'category.dart';
import 'city.dart';
import 'slider.dart';

class ExtraData {
  List<Category>? categories;
  List<City>? cities;
  List<SliderModel>? sliders;

  ExtraData({this.categories, this.cities, this.sliders});

  factory ExtraData.fromJson(Map<String, dynamic> json) => ExtraData(
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        cities: (json['cities'] as List<dynamic>?)
            ?.map((e) => City.fromJson(e as Map<String, dynamic>))
            .toList(),
        sliders: (json['sliders'] as List<dynamic>?)
            ?.map((e) => SliderModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'categories': categories?.map((e) => e.toJson()).toList(),
        'cities': cities?.map((e) => e.toJson()).toList(),
        'sliders': sliders?.map((e) => e.toJson()).toList(),
      };
}
