// product_cubit.dart (يمكن إعادة استخدامه للصفحات الأخرى)
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hezmaa/Services/get_prodects.dart';

import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

// Define states
abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProdectModel> products;

  ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}

// Define cubit
class ProductCubit extends Cubit<ProductState> {
  final ProdectService _prodectService;

  ProductCubit(this._prodectService) : super(ProductInitial());

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await _prodectService.getProdects();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
