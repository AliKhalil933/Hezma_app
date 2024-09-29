import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/get_order_detalis.dart';
import 'package:hezmaa/cubits/orders_cubit/order_detailes_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderDtailesServes _orderDetailsService;

  OrderDetailsCubit(this._orderDetailsService) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    try {
      final orderDetails = await _orderDetailsService.getOrderDetails(orderId);
      emit(OrderDetailsLoaded(orderDetails));
    } catch (e) {
      emit(OrderDetailsError(e.toString()));
    }
  }
}
