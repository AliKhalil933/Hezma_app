import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/get_order.dart';
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderStateOfOrder> {
  final OrderService _orderService;

  OrderCubit(this._orderService) : super(OrderInitial());

  Future<void> fetchOrders() async {
    emit(OrderLoading());
    try {
      final response = await _orderService.getOrders();

      if (response?['status'] == true) {
        final List<dynamic> ordersData =
            response?['data'] as List<dynamic>? ?? [];
        final orders =
            ordersData.map((data) => ModelcartDetails.fromJson(data)).toList();

        // استخراج الطلبات الملغاة بشكل صحيح
        final List<dynamic> canceledOrdersData =
            response?['extra_data']['Canceled'] as List<dynamic>? ?? [];
        final canceledOrders = canceledOrdersData
            .map((data) => ModelcartDetails.fromJson(data))
            .toList();

        emit(OrderLoaded(orders: orders, canceledOrders: canceledOrders));
      } else {
        emit(OrderError(response?['message'] ?? 'حدث خطأ غير معروف'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
