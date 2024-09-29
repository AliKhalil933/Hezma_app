// Define the different states
import 'package:equatable/equatable.dart';

abstract class OrderStateOfMakeOrder extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderStateOfMakeOrder {}

class OrderLoading extends OrderStateOfMakeOrder {}

class OrderSuccess extends OrderStateOfMakeOrder {
  final String message;

  OrderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderFailure extends OrderStateOfMakeOrder {
  final String message;

  OrderFailure(this.message);

  @override
  List<Object?> get props => [message];
}
