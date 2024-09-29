import 'detail..cart.model.dart';

class NewCartModel {
  int? cartId;
  String? quantity;
  String? totalPrice;
  List<DetailCartModel>? details;
  dynamic product;

  NewCartModel({
    this.cartId,
    this.quantity,
    this.totalPrice,
    this.details,
    this.product,
  });

  factory NewCartModel.fromJson(Map<String, dynamic> json) => NewCartModel(
        cartId: json['cart_id'] as int?,
        quantity: json['quantity'] as String?,
        totalPrice: json['total_price'] as String?,
        details: (json['details'] as List<dynamic>?)
            ?.map((e) => DetailCartModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        product: json['product'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'cart_id': cartId,
        'quantity': quantity,
        'total_price': totalPrice,
        'details': details?.map((e) => e.toJson()).toList(),
        'product': product,
      };
}
