import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/address_post_creat.dart';

// حالات CreateAddressState
abstract class CreateAddressState {}

class CreateAddressInitial extends CreateAddressState {}

class CreateAddressLoading extends CreateAddressState {}

class CreateAddressSuccess extends CreateAddressState {
  final String message;

  CreateAddressSuccess(this.message);
}

class CreateAddressFailure extends CreateAddressState {
  final String errorMessage;

  CreateAddressFailure(this.errorMessage);
}

// CreateAddressCubit
class CreateAddressCubit extends Cubit<CreateAddressState> {
  final AdressPostCreatService addressCreateService;

  CreateAddressCubit(this.addressCreateService) : super(CreateAddressInitial());

  Future<void> createAddress({
    required String name,
    required String address,
    required String latitude,
    required String longitude,
    required int districtId,
    required String distance,
  }) async {
    emit(CreateAddressLoading());

    try {
      final addressData = await addressCreateService.createAddress(
        name,
        address,
        latitude,
        longitude,
        districtId,
        distance,
      );

      if (addressData != null) {
        emit(CreateAddressSuccess('تم إضافة عنوان بنجاح'));
      } else {
        emit(CreateAddressFailure('فشل في إضافة العنوان.'));
      }
    } catch (e) {
      emit(CreateAddressFailure(e.toString()));
    }
  }
}
