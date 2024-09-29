import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

// Cubit States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProdectModel> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// Cubit
class ProductCubit extends Cubit<ProductState> {
  final ProdectService _prodectService;

  ProductCubit(this._prodectService) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await _prodectService.getProdects();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
