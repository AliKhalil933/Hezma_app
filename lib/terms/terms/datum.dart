class Datum {
  String? name;
  String? value;

  Datum({this.name, this.value});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json['name'] as String?,
        value: json['value'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}
