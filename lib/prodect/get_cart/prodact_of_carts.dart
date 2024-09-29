import 'package:hezmaa/home/home/product.dart';
import 'package:hezmaa/prodect/get_cart/detail.dart';

class ProdactModelsForCart {
  final int cartId;
  final String quantity;
  final String totalPrice;
  final List<Detail> details;
  final Product? product;

  ProdactModelsForCart({
    required this.cartId,
    required this.quantity,
    required this.totalPrice,
    required this.details,
    this.product,
  });

  factory ProdactModelsForCart.fromJson(Map<String, dynamic> json) {
    var detailsFromJson = json['details'] as List;
    List<Detail> detailsList =
        detailsFromJson.map((i) => Detail.fromJson(i)).toList();

    return ProdactModelsForCart(
      cartId: json['cart_id'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      details: detailsList,
      product: json['product'] != null
          ? Product.fromJson(json['product']) // Safely deserialize product
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'cart_id': cartId,
        'quantity': quantity,
        'total_price': totalPrice,
        'details': details.map((e) => e.toJson()).toList(),
        'product': product?.toJson(), // Safely serialize product
      };
}
