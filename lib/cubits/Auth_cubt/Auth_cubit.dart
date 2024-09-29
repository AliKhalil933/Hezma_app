import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// OtpState: الحالات المختلفة لـ OTP
abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final String otp;

  const OtpSuccess(this.otp);

  @override
  List<Object> get props => [otp];
}

class OtpFailure extends OtpState {
  final String error;

  const OtpFailure(this.error);

  @override
  List<Object> get props => [error];
}

// OtpCubit: الكيوبت لإدارة حالات OTP
class OtpCubit extends Cubit<OtpState> {
  final OtpServicesSend otpServices;

  OtpCubit(this.otpServices) : super(OtpInitial());

  Future<void> sendOtp() async {
    emit(OtpLoading());

    try {
      final otp = await otpServices.sendOtp();
      emit(OtpSuccess(otp));
    } catch (e) {
      emit(OtpFailure(e.toString()));
    }
  }
}

// OtpServicesSend: خدمة إرسال OTP
class OtpServicesSend {
  final storage = FlutterSecureStorage();

  Future<String> sendOtp() async {
    try {
      String? token = await storage.read(key: 'register_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final url =
          Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/send_otp');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final otp = data['otp'];
        print('OTP: $otp');
        return otp;
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
