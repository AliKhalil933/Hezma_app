import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/cubits/favourit_cubit/favoirte_state.dart';
import 'package:hezmaa/cubits/favourit_cubit/favorite_cubit.dart';
import 'package:hezmaa/widgets/custom_card.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'المفضلة',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'STVBold',
          ),
        ),
      ),
      body: BlocListener<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoriteOperationSuccess) {
            // عرض SnackBar في حالة النجاح
            _showCustomCenteredSnackBar(
              context,
              state.message,
            );
          } else if (state is FavoriteOperationError) {
            // عرض SnackBar في حالة الفشل
            _showCustomCenteredSnackBar(
              context,
              'حدث خطأ: ${state.message}',
            );
          }
        },
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return const Center(
                  child: Text(
                    'للأسف لم تقم بإضافة أي منتجات حتى الآن',
                    style: TextStyle(fontFamily: 'STVBold', fontSize: 18),
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return CustomCard(product: product);
                },
              );
            } else if (state is FavoritesError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else {
              return const Center(child: Text('لا توجد منتجات مفضلة.'));
            }
          },
        ),
      ),
    );
  }

  void _showCustomCenteredSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 11,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'STVBold',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2))
        .then((_) => overlayEntry.remove());
  }
}
