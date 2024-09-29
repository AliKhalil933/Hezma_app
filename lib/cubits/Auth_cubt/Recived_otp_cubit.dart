import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// OtpVerifyState: الحالات المختلفة لعملية التحقق من OTP
abstract class OtpVerifyState extends Equatable {
  const OtpVerifyState();

  @override
  List<Object> get props => [];
}

class OtpVerifyInitial extends OtpVerifyState {}

class OtpVerifyLoading extends OtpVerifyState {}

class OtpVerifySuccess extends OtpVerifyState {
  final String message;

  const OtpVerifySuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OtpVerifyFailure extends OtpVerifyState {
  final String error;

  const OtpVerifyFailure(this.error);

  @override
  List<Object> get props => [error];
}

// OtpVerifyCubit: الكيوبت لإدارة حالات التحقق من OTP
class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  final OtpServicesReceived otpServices;

  OtpVerifyCubit(this.otpServices) : super(OtpVerifyInitial());

  Future<void> verifyOtp() async {
    emit(OtpVerifyLoading());

    try {
      final message = await otpServices.verifyOtp();
      emit(OtpVerifySuccess(message));
    } catch (e) {
      emit(OtpVerifyFailure(e.toString()));
    }
  }
}

// OtpServicesReceived: خدمة التحقق من OTP
class OtpServicesReceived {
  final storage = FlutterSecureStorage();

  Future<String> verifyOtp() async {
    try {
      String? token = await storage.read(key: 'register_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      String? otp = await storage.read(key: 'otp');

      if (otp == null) {
        throw Exception('OTP not found');
      }

      final url =
          Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/received_otp');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']; // أو أي رسالة تأكيد أخرى
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
