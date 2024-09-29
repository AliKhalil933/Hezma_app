import 'package:bloc/bloc.dart';
import 'package:hezmaa/cubits/Auth_cubt/Auth_serves_login.dart';
import 'package:hezmaa/cubits/Auth_cubt/login_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String emailOrPhone,
    required String password,
    required bool isEmail,
  }) async {
    emit(LoginLoading());
    print("Login started...");

    final url = 'https://hezma-traning.eltamiuz.net/api/v1/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': isEmail ? null : emailOrPhone,
          'login_by': isEmail ? 'email' : 'phone',
          'email': isEmail ? emailOrPhone : null,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status']) {
          final data = responseData['data'];
          emit(LoginSuccess(
            userId: data['id'],
            name: data['name'],
            token: responseData['token'],
          ));
          print("Login success!");
        } else {
          emit(LoginFailure(responseData['message']));
          print("Login failed: ${responseData['message']}");
        }
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        final errorData = jsonDecode(response.body);
        emit(LoginFailure('Error: ${errorData['message']}'));
        print("Error: ${errorData['message']}");
      } else {
        emit(LoginFailure(
            'Request failed with status: ${response.statusCode}.'));
        print("Login request failed with status: ${response.statusCode}");
      }
    } catch (error) {
      emit(LoginFailure('An error occurred: $error'));
      print("Login error: $error");
    }
  }

  Future<void> logout() async {
    try {
      final authService = AuthService();
      await authService.logout();
      emit(
          LoginInitial()); // إعادة تعيين الحالة إلى الحالة الأولية بعد تسجيل الخروج
    } catch (error) {
      print("Logout error: $error");
    }
  }
}
