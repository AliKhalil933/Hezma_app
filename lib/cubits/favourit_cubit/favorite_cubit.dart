import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/delet_favorites.dart';
import 'package:hezmaa/Services/get_favorites.dart';
import 'package:hezmaa/Services/post_favorites.dart';
import 'package:hezmaa/cubits/favourit_cubit/favoirte_state.dart';

import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart'; // استيراد النموذج المناسب

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesServesGet favoritesServesGet;
  final FavoritesServesPost favoritesServesPost;
  final FavoritesServesDelete favoritesServesDelete;

  FavoritesCubit({
    required this.favoritesServesGet,
    required this.favoritesServesPost,
    required this.favoritesServesDelete,
  }) : super(FavoritesInitial());

  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await favoritesServesGet.fetchFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> addFavorite(int productId) async {
    await _performFavoriteOperation(
      () => favoritesServesPost.addFavorite(productId),
      'تم إضافة المنتج إلى المفضلة بنجاح',
    );
  }

  Future<void> removeFavorite(ProdectModel product) async {
    await _performFavoriteOperation(
      () async {
        await favoritesServesDelete.removeFavorite(product.id as int);
      },
      'تم إزالة المنتج من المفضلة بنجاح',
    );
  }

  Future<void> _performFavoriteOperation(
    Future<void> Function() operation,
    String successMessage,
  ) async {
    emit(FavoritesLoading());
    try {
      await operation();
      emit(FavoriteOperationSuccess(successMessage));
      fetchFavorites(); // Refresh the list after the operation
    } catch (e) {
      emit(FavoriteOperationError(e.toString()));
    }
  }
}
