class CustomerDetails {
  String? name;
  String? email;
  String? street1;
  String? city;
  String? state;
  String? country;
  String? ip;

  CustomerDetails({
    this.name,
    this.email,
    this.street1,
    this.city,
    this.state,
    this.country,
    this.ip,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] as String?,
      email: json['email'] as String?,
      street1: json['street1'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      ip: json['ip'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'street1': street1,
        'city': city,
        'state': state,
        'country': country,
        'ip': ip,
      };
}
