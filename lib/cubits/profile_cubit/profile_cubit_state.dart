import 'package:equatable/equatable.dart';

import 'package:hezmaa/models/model_login/prodact_model_login.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProdactModelLoginAndRegister profile;
  final bool isProfileUpdated;

  const ProfileSuccess(this.profile, {this.isProfileUpdated = false});

  @override
  List<Object> get props => [profile, isProfileUpdated];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}
