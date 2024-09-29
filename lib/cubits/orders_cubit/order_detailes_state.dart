import 'package:equatable/equatable.dart';
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';

// حالات الطلبات
abstract class OrderDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  final ModelcartDetails orderDetails;

  OrderDetailsLoaded(this.orderDetails);

  @override
  List<Object?> get props => [orderDetails];
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  OrderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
