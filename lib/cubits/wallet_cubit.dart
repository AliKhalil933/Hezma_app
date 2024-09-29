import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hezmaa/Services/get_wallet.dart';
import 'package:hezmaa/wallet/wallet.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletFetchService _walletFetchService;

  WalletCubit(this._walletFetchService) : super(WalletInitial());

  Future<void> fetchWallet(String token) async {
    emit(WalletLoading());
    try {
      final wallet = await _walletFetchService.fetchWallet(token);
      if (wallet != null) {
        emit(WalletLoaded(wallet));
      } else {
        emit(WalletError('فشل في جلب بيانات المحفظة'));
      }
    } catch (e) {
      emit(WalletError('حدث خطأ أثناء جلب بيانات المحفظة: $e'));
    }
  }
}

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final Wallet wallet;

  WalletLoaded(this.wallet);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
