import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:hezmaa/Views/screens/setting_card.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/cubits/favourit_cubit/favoirte_state.dart';
import 'package:hezmaa/cubits/favourit_cubit/favorite_cubit.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class CustomCard extends StatefulWidget {
  final ProdectModel product;

  const CustomCard({required this.product, Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  double rating = 2;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _updateFavoriteStatus();
  }

  void _updateFavoriteStatus() {
    final state = context.read<FavoritesCubit>().state;
    _isFavorite = state is FavoritesLoaded &&
        state.favorites.any((fav) => fav.id == widget.product.id);
  }

  void _toggleFavorite() async {
    final favoritesCubit = context.read<FavoritesCubit>();
    try {
      if (_isFavorite) {
        await favoritesCubit.removeFavorite(widget.product);
      } else {
        await favoritesCubit.addFavorite(widget.product.id!);
      }
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });

        _showCustomCenteredSnackBar(
          context,
          _isFavorite
              ? 'تم إضافة المنتج إلى المفضلة'
              : 'تم إزالة المنتج من المفضلة',
        );
      }
    } catch (e) {
      if (mounted) {
        _showCustomCenteredSnackBar(context, 'حدث خطأ، يرجى المحاولة مرة أخرى');
      }
    }
  }

  void _addToCart() async {
    try {
      await context
          .read<CartManagementCubit>()
          .addProductToCart(widget.product, 1);
      await context.read<CartManagementCubit>().fetchProducts();
      if (mounted) {
        _showCustomCenteredSnackBar(context, 'تم إضافة المنتج إلى السلة');
      }
    } catch (e) {
      if (mounted) {
        _showCustomCenteredSnackBar(context, 'حدث خطأ، يرجى المحاولة مرة أخرى');
      }
    }
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
                    fontSize: 12,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Intropage12(
              productId: widget.product.id!,
              prodect: widget.product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xffF0F0F0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 1,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(backgroundcolor2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: _addToCart,
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Color(backgroundcolor1),
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(backgroundcolor1),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.network(widget.product.image ?? ''),
                          ),
                          Positioned(
                            top: -5,
                            left: -5,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: _isFavorite
                                      ? const Color(0xffBDEB79)
                                      : const Color(backgroundcolor2),
                                ),
                                IconButton(
                                  onPressed: _toggleFavorite,
                                  icon: Icon(
                                    Icons.favorite,
                                    color: _isFavorite
                                        ? const Color(backgroundcolor2)
                                        : const Color(backgroundcolor1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.product.name ?? 'اسم المنتج',
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'STVBold',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PannableRatingBar(
                                textDirection: TextDirection.rtl,
                                rate: rating,
                                items: List.generate(
                                    5,
                                    (index) => const RatingWidget(
                                          selectedColor: Colors.green,
                                          unSelectedColor:
                                              Color(backgroundcolor1),
                                          child: Icon(
                                            Icons.star,
                                            size: 15,
                                          ),
                                        )),
                                onChanged: (value) {
                                  setState(() {
                                    rating = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'ر.س/كجم',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'STVBold',
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              widget.product.price ?? 'السعر غير متوفر',
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'STVBold',
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
