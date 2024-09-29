import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/post_copon.dart';
import 'package:hezmaa/cubits/coupon_cubit/coupon_cubit_sTATS.dart';
import 'package:hezmaa/models/model_copoun/model_coboun/data.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponService couponService;

  CouponCubit(this.couponService) : super(CouponInitial());

  Future<void> verifyCoupon(String couponCode) async {
    try {
      emit(CouponLoading()); // إظهار حالة التحميل
      final coupon =
          await couponService.verifyCoupon(couponCode); // التحقق من الكوبون
      if (coupon != null) {
        emit(CouponSuccess(coupon as copounOfModel)); // في حالة النجاح
      } else {
        emit(CouponFailure('Failed to verify coupon.')); // في حالة الفشل
      }
    } catch (error) {
      emit(CouponFailure(error.toString())); // في حالة الفشل
    }
  }
}
