// favorite_state.dart
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProdectModel> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

class FavoriteOperationSuccess extends FavoritesState {
  final String message;
  FavoriteOperationSuccess(this.message);
}

class FavoriteOperationError extends FavoritesState {
  final String message;
  FavoriteOperationError(this.message);
}
