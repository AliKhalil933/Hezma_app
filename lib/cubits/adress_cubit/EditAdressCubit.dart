import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hezmaa/Services/adress_post_edite.dart';

class EditAddressCubit extends Cubit<EditAddressState> {
  final AdressPostEditeService addressEditService;

  EditAddressCubit(this.addressEditService) : super(EditAddressInitial());

  Future<void> editAddress({
    required String name,
    required String address,
    required String latitude,
    required String longitude,
    required String distance,
    required int addressId,
    required int districtId, // Add this parameter
  }) async {
    emit(EditAddressLoading());

    if (name.isEmpty ||
        address.isEmpty ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      emit(EditAddressFailure('يجب ملء جميع الحقول.'));
      return;
    }

    try {
      final addressData = await addressEditService.editeAddress(
        addressId: addressId,
        name: name,
        address: address,
        lat: latitude,
        lng: longitude,
        distance: distance,
        districtId: districtId, // Pass the districtId
      );

      if (addressData != null) {
        emit(EditAddressSuccess('تم تعديل العنوان بنجاح.'));
      } else {
        emit(EditAddressFailure('فشل في تعديل العنوان.'));
      }
    } catch (e) {
      emit(EditAddressFailure('حدث خطأ: ${e.toString()}'));
    }
  }
}

abstract class EditAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditAddressInitial extends EditAddressState {}

class EditAddressLoading extends EditAddressState {}

class EditAddressSuccess extends EditAddressState {
  final String message;

  EditAddressSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EditAddressFailure extends EditAddressState {
  final String errorMessage;

  EditAddressFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
