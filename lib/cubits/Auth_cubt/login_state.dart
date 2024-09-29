import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final int userId;
  final String name;
  final String token;

  LoginSuccess({
    required this.userId,
    required this.name,
    required this.token,
  });

  @override
  List<Object> get props => [userId, name, token];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object> get props => [error];

  String get errorMessage => error; // تصحيح: إعادة القيمة الصحيحة
}
