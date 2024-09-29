import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hezmaa/Services/post_order_canceld.dart';

class OrderCancelCubit extends Cubit<OrderCancelState> {
  final OrderCanceledService _orderCanceledService;

  OrderCancelCubit(this._orderCanceledService)
      : super(OrderCancelState.initial());

  Future<void> cancelOrder(int orderId) async {
    emit(state.copyWith(status: OrderCancelStatus.loading));

    try {
      await _orderCanceledService.cancelOrder(orderId);
      emit(state.copyWith(status: OrderCancelStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: OrderCancelStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

class OrderCancelState extends Equatable {
  final OrderCancelStatus status;
  final String? errorMessage;

  const OrderCancelState({required this.status, this.errorMessage});

  factory OrderCancelState.initial() {
    return OrderCancelState(status: OrderCancelStatus.initial);
  }

  OrderCancelState copyWith({OrderCancelStatus? status, String? errorMessage}) {
    return OrderCancelState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

enum OrderCancelStatus { initial, loading, success, failure }
