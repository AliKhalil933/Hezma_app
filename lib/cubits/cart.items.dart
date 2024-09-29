import 'package:equatable/equatable.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class CartItem extends Equatable {
  final ProdectModel product;
  final int quantity;

  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  CartItem copyWith({ProdectModel? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}
