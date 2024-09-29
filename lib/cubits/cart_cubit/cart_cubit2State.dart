import 'package:equatable/equatable.dart';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';

class CartState2 extends Equatable {
  final List<ProdactModelsForCart> cartItems;
  final bool isLoading;
  final String? error;
  final String? totalPrice;

  const CartState2({
    this.cartItems = const [],
    this.isLoading = false,
    this.error,
    this.totalPrice,
  });

  CartState2 copyWith({
    List<ProdactModelsForCart>? cartItems,
    bool? isLoading,
    String? error,
    String? totalPrice,
  }) {
    return CartState2(
      cartItems: cartItems ?? this.cartItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [cartItems, isLoading, error, totalPrice];
}
