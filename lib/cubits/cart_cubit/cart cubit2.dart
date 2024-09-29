import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/delet%20_prodect_fromcart.dart';
import 'package:hezmaa/Services/get_cart.dart';
import 'package:hezmaa/Services/post_add_prodact.dart';
import 'package:hezmaa/Services/post_decrement.dart';
import 'package:hezmaa/Services/post_update_cart.dart';
import 'package:hezmaa/cubits/cart_cubit/cart_cubit2State.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class CartManagementCubit extends Cubit<CartState2> {
  final AddProductService _addProductService;
  final DecrementService _decrementService;
  final DeletProdectCartService _deleteProductService;
  final UpdateCartService _updateCartService;
  final ProdectServiceDitels _prodectServiceDitels;

  CartManagementCubit(
    this._addProductService,
    this._decrementService,
    this._deleteProductService,
    this._updateCartService,
    this._prodectServiceDitels,
  ) : super(const CartState2());

  Future<void> addProductToCart(ProdectModel product, int quantity) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _addProductService.addProductToCart(
        product.id!,
        quantity,
        double.parse(product.price ?? '0'),
      );
      await fetchProducts();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> decrementProductCount(int productId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _decrementService.decrementProductCountInCart(productId);
      await fetchProducts();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteProductFromCart(int cartId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _deleteProductService.deleteProductFromCart(cartId);
      await fetchProducts(); // Refresh product list after deletion
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateProductCount(int cartId, int newCount) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('Cart ID passed for update: $cartId');

      // Fetch updated cart items
      final cartItems = await _prodectServiceDitels.getProdects();

      // Print fetched data for debugging
      print('Fetched cart items: $cartItems');

      // Find the product in the cart
      final productInCart = cartItems.firstWhere(
        (item) => item.cartId == cartId,
        orElse: () {
          throw Exception(
              'Product with cartId $cartId not found in cart items');
        },
      );

      print('Product found in cart: ${productInCart.cartId}');

      // Update the product count
      final response =
          await _updateCartService.updateProductCountInCart(cartId, newCount);

      print('Update response status: ${response['status']}');
      print('Update response message: ${response['message']}');

      if (response['status'] == false) {
        emit(state.copyWith(isLoading: false, error: response['message']));
        return;
      }

      // Reload data after update
      await fetchProducts();
    } catch (e) {
      print('Error updating product count: $e');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchProducts() async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await _prodectServiceDitels.getProdects();
      emit(state.copyWith(cartItems: products, isLoading: false));
      print('Fetched cart items: $products'); // Debug print
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isLoading: true)); // حالة تحميل
    try {
      // استرجاع عناصر السلة
      final cartItems = await _prodectServiceDitels.getProdects();

      // حذف كل عنصر في السلة
      for (var item in cartItems) {
        await _deleteProductService.deleteProductFromCart(item.cartId);
      }

      // إعادة تحميل العناصر بعد الحذف
      await fetchProducts();
      emit(state.copyWith(isLoading: false)); // إنهاء حالة التحميل
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: e.toString())); // في حالة حدوث خطأ
    }
  }
}
