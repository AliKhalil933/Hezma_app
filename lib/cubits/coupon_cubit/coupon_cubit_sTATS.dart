import 'package:equatable/equatable.dart';
import 'package:hezmaa/models/model_copoun/model_coboun/data.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponSuccess extends CouponState {
  final copounOfModel coupon;

  const CouponSuccess(this.coupon);

  @override
  List<Object?> get props => [coupon];
}

class CouponFailure extends CouponState {
  final String error;

  const CouponFailure(this.error);

  @override
  List<Object?> get props => [error];
}
