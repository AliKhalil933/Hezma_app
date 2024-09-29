import 'package:equatable/equatable.dart';
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';

abstract class OrderStateOfOrder extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderStateOfOrder {}

class OrderLoading extends OrderStateOfOrder {}

class OrderLoaded extends OrderStateOfOrder {
  final List<ModelcartDetails> orders;
  final List<ModelcartDetails> canceledOrders; // إضافة الطلبات الملغاة

  OrderLoaded({
    required this.orders,
    required this.canceledOrders,
  });

  @override
  List<Object?> get props =>
      [orders, canceledOrders]; // إضافة الطلبات الملغاة هنا
}

class OrderError extends OrderStateOfOrder {
  final String message;

  OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
