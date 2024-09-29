import 'package:hezmaa/Services/post_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // احفظ هنا التوكن في التخزين المحلي
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // إزالة التوكن من التخزين المحلي
  Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  // الحصول على التوكن من التخزين المحلي
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}

Future<void> _chargeWallet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('authToken'); // استرجاع التوكن المخزن

  if (token != null) {
    try {
      String result = await WalletService.chargeWallet(
        token: token, // تمرير التوكن
        amount: '100', // القيمة التي تريد شحنها
        paymentMethodId: '1', // معرف طريقة الدفع
      );
      print(result); // التعامل مع النتيجة هنا، مثل عرض رسالة نجاح أو فشل.
    } catch (e) {
      print('Error charging wallet: $e');
    }
  } else {
    print('No token found, please login first.');
  }
}

class AuthService {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('register_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('register_token');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('register_token');
  }
}

Future<void> fetchWallet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('authToken');

  if (token != null) {
    try {
      String result = await WalletService.chargeWallet(
        token: token, // تمرير التوكن
        amount: '100', // القيمة التي تريد شحنها
        paymentMethodId: '1', // معرف طريقة الدفع
      );
      print(result); // التعامل مع النتيجة هنا، مثل عرض رسالة نجاح أو فشل.
    } catch (e) {
      print('Error charging wallet: $e');
    }
  } else {
    print('No token found, please login first.');
  }
}
