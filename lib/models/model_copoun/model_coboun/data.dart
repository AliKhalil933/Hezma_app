class copounOfModel {
  final int id;
  final String code;
  final String value;
  final String isValue;

  copounOfModel({
    required this.id,
    required this.code,
    required this.value,
    required this.isValue,
  });

  factory copounOfModel.fromJson(Map<String, dynamic> json) {
    return copounOfModel(
      id: json['id'],
      code: json['code'],
      value: json['value'],
      isValue: json['is_value'],
    );
  }
}
