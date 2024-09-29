class ShippingDetails {
  String? name;
  String? email;
  String? street1;
  String? city;
  String? state;
  String? country;

  ShippingDetails({
    this.name,
    this.email,
    this.street1,
    this.city,
    this.state,
    this.country,
  });

  factory ShippingDetails.fromJson(Map<String, dynamic> json) {
    return ShippingDetails(
      name: json['name'] as String?,
      email: json['email'] as String?,
      street1: json['street1'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'street1': street1,
        'city': city,
        'state': state,
        'country': country,
      };
}
