import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hezmaa/Services/address_post_creat.dart';
import 'package:hezmaa/Services/adress_Get_ditales.dart';
import 'package:hezmaa/Services/adress_post_edite.dart';
import 'package:hezmaa/Services/adress_servess.dart';
import 'package:hezmaa/Services/delet%20_prodect_fromcart.dart';
import 'package:hezmaa/Services/delet_favorites.dart';
import 'package:hezmaa/Services/get_cart.dart';
import 'package:hezmaa/Services/get_favorites.dart';
import 'package:hezmaa/Services/get_order.dart';
import 'package:hezmaa/Services/get_order_detalis.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/Services/get_profile.dart';
import 'package:hezmaa/Services/post_add_prodact.dart';
import 'package:hezmaa/Services/post_copon.dart';
import 'package:hezmaa/Services/post_decrement.dart';
import 'package:hezmaa/Services/post_favorites.dart';
import 'package:hezmaa/Services/post_make%20order.dart';
import 'package:hezmaa/Services/post_order_canceld.dart';
import 'package:hezmaa/Services/post_profile.dart';
import 'package:hezmaa/Services/post_update_cart.dart';
import 'package:hezmaa/cubits/adress_cubit/CreateAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/DeletAdressCubit.dart';
import 'package:hezmaa/cubits/adress_cubit/EditAdressCubit.dart';
import 'package:hezmaa/cubits/cart_cubit/cart%20cubit2.dart';
import 'package:hezmaa/cubits/coupon_cubit/coubon_cubit.dart';
import 'package:hezmaa/cubits/favourit_cubit/favorite_cubit.dart';
import 'package:hezmaa/cubits/adress_cubit/getAdressCubit.dart';
import 'package:hezmaa/cubits/Auth_cubt/login_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/mack_order_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/order_canceld_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/order_cubit.dart';
import 'package:hezmaa/cubits/orders_cubit/order_detels_cubit.dart';
import 'package:hezmaa/cubits/product_cubit.dart';
import 'package:hezmaa/cubits/profile_cubit/profile_cubit.dart';
import 'package:hezmaa/helper/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الخدمات كما هو موضح
  final productService = ProdectService();
  final favoriteGetService = FavoritesServesGet();
  final favoritePostService = FavoritesServesPost();
  final favoriteDeleteService = FavoritesServesDelete();
  final addressGetService = AdressGetServes();
  final addressPostEditeService = AdressPostEditeService();
  final addressPostCreateService = AdressPostCreatService();
  final addressDeletService = AddressDeletService();
  final couponService = CouponService();
  final profileServiceGet = ProfileServiceget();
  final profileServicePost = ProfileServicepost();

  final addProductService = AddProductService();
  final decrementService = DecrementService();
  final deleteProductService = DeletProdectCartService();
  final updateCartService = UpdateCartService();
  final prodectServiceDitels = ProdectServiceDitels();
  final orderService = OrderService();
  final orderCanceledService = OrderCanceledService();
  final orderDetailsService = OrderDtailesServes();
  final makeOrderService = MakeOrderService();

  runApp(
    ScreenUtilInit(
      designSize: Size(360, 690), // حدد حجم التصميم المناسب
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProductCubit(productService)..fetchProducts(),
            ),
            BlocProvider(
              create: (context) => CartManagementCubit(
                addProductService,
                decrementService,
                deleteProductService,
                updateCartService,
                prodectServiceDitels,
              )..fetchProducts(),
            ),
            BlocProvider(
              create: (context) => FavoritesCubit(
                favoritesServesGet: favoriteGetService,
                favoritesServesPost: favoritePostService,
                favoritesServesDelete: favoriteDeleteService,
              )..fetchFavorites(),
            ),
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(
              create: (context) =>
                  GetAddressesCubit(addressGetService)..fetchAddresses(),
            ),
            BlocProvider(
                create: (context) =>
                    CreateAddressCubit(addressPostCreateService)),
            BlocProvider(
                create: (context) => EditAddressCubit(addressPostEditeService)),
            BlocProvider(
                create: (context) => DelAddressCubit(addressDeletService)),
            BlocProvider(create: (context) => CouponCubit(couponService)),
            BlocProvider(
              create: (context) => OrderCubit(orderService)..fetchOrders(),
            ),
            BlocProvider(
              create: (context) => OrderCancelCubit(orderCanceledService),
            ),
            BlocProvider(
              create: (context) => OrderDetailsCubit(orderDetailsService),
            ),
            BlocProvider(
              create: (context) => MakeOrderCubit(makeOrderService),
            ),
            BlocProvider(
              create: (context) => ProfileCubit(
                profileServiceGet: profileServiceGet,
                profileServicePost: profileServicePost,
              )..fetchProfile(),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRoutes.router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    ),
  );
}
