import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/adress_servess.dart';

abstract class DelAddressState {}

class DelAddressInitial extends DelAddressState {}

class DelAddressLoading extends DelAddressState {}

class DelAddressSuccess extends DelAddressState {}

class DelAddressFailure extends DelAddressState {
  final String errorMessage;

  DelAddressFailure(this.errorMessage);
}

class DelAddressCubit extends Cubit<DelAddressState> {
  final AddressDeletService addressDeletService;

  DelAddressCubit(this.addressDeletService) : super(DelAddressInitial());

  Future<void> delAddresses({required int id}) async {
    emit(DelAddressLoading()); // Emit loading state

    try {
      // استدعاء الخدمة لحذف العنوان
      final bool result = await addressDeletService.deleteAddress(id);

      // تحقق من نتيجة الحذف
      if (result) {
        emit(DelAddressSuccess()); // Emit success state
      } else {
        emit(
            DelAddressFailure('فشل حذف العنوان.')); // Emit failure with message
      }
    } catch (e) {
      emit(DelAddressFailure(
          'حدث خطأ: ${e.toString()}')); // Emit failure with exception message
    }
  }
}
