import 'product.dart';

class Cart {
  int? cartId;
  String? quantity;
  String? totalPrice;
  List<dynamic>? details;
  Product? product;

  Cart({
    this.cartId,
    this.quantity,
    this.totalPrice,
    this.details,
    this.product,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json['cart_id'] as int?,
        quantity: json['quantity'] as String?,
        totalPrice: json['total_price'] as String?,
        details: json['details'] as List<dynamic>?,
        product: json['product'] == null
            ? null
            : Product.fromJson(json['product'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'cart_id': cartId,
        'quantity': quantity,
        'total_price': totalPrice,
        'details': details,
        'product': product?.toJson(),
      };
}
