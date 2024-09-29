import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/post_make%20order.dart';
import 'package:hezmaa/cubits/orders_cubit/mackorder_state.dart'; // تأكد من اسم الملف هنا

class MakeOrderCubit extends Cubit<OrderStateOfMakeOrder> {
  final MakeOrderService _orderService;

  MakeOrderCubit(this._orderService) : super(OrderInitial());

  Future<void> makeOrder({
    required String couponCode,
    required int paymentMethodId,
    required int addressId,
    required int timeId,
    required String date,
    required double shipping,
    required String userName,
    required String bankName,
    File? image,
  }) async {
    emit(OrderLoading());
    try {
      await _orderService.makeOrder(
        couponCode: couponCode,
        paymentMethodId: paymentMethodId,
        addressId: addressId,
        timeId: timeId,
        date: date,
        shipping: shipping,
        userName: userName,
        bankName: bankName,
        image: image,
      );
      emit(OrderSuccess('تم إنشاء الطلب بنجاح.'));
    } catch (e) {
      print('Error in makeOrder: $e');
      emit(OrderFailure('فشل في إنشاء الطلب: ${e.toString()}'));
    }
  }
}
