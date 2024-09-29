import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hezmaa/Services/adress_Get_ditales.dart';

import 'package:hezmaa/adress/adress/modelAdress.dart';

class GetAddressesCubit extends Cubit<GetAddressesState> {
  final AdressGetServes addressGetService;

  GetAddressesCubit(this.addressGetService) : super(GetAddressesInitial());

  Future<void> fetchAddresses() async {
    emit(GetAddressesLoading());

    try {
      final addresses = await addressGetService.getProdects();
      if (addresses.isNotEmpty) {
        emit(GetAddressesSuccess(addresses));
      } else {
        emit(GetAddressesFailure('لا توجد عناوين متاحة.'));
      }
    } catch (e) {
      emit(GetAddressesFailure(e.toString()));
    }
  }

  void searchAddresses(String value) {}
}

abstract class GetAddressesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAddressesInitial extends GetAddressesState {}

class GetAddressesLoading extends GetAddressesState {}

class GetAddressesSuccess extends GetAddressesState {
  final List<modelofAdress> addresses;

  GetAddressesSuccess(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class GetAddressesFailure extends GetAddressesState {
  final String errorMessage;

  GetAddressesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
