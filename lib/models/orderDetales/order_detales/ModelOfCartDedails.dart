import 'dart:convert';

class ModelcartDetails {
  final int orderId;
  final String usedCoupon;
  final double couponPrice;
  final String couponCode;
  final double totalPrice;
  final double productsPrice;
  final double shipping;
  final double tax;
  final String status;
  final String statusName;
  final String tracking;
  final String trackingName;
  final String paymentMethod;
  final String orderDate;
  final String orderTime;
  final String orderDeliveryData;
  final String orderDeliveryTime;
  final List<dynamic> cart;
  final Map<String, dynamic> user;
  final Map<String, dynamic> address;

  ModelcartDetails({
    required this.orderId,
    required this.usedCoupon,
    required this.couponPrice,
    required this.couponCode,
    required this.totalPrice,
    required this.productsPrice,
    required this.shipping,
    required this.tax,
    required this.status,
    required this.statusName,
    required this.tracking,
    required this.trackingName,
    required this.paymentMethod,
    required this.orderDate,
    required this.orderTime,
    required this.orderDeliveryData,
    required this.orderDeliveryTime,
    required this.cart,
    required this.user,
    required this.address,
  });

  factory ModelcartDetails.fromJson(Map<String, dynamic> json) {
    return ModelcartDetails(
      orderId: json['order_id'] as int? ?? 0,
      usedCoupon: json['used_coupon']?.toString() ?? '',
      couponPrice: _parseDouble(json['coupon_price']),
      couponCode: json['coupon_code']?.toString() ?? '',
      totalPrice: _parseDouble(json['total_price']),
      productsPrice: _parseDouble(json['products_price']),
      shipping: _parseDouble(json['shipping']),
      tax: _parseDouble(json['tax']),
      status: json['status']?.toString() ?? '',
      statusName: json['status_name']?.toString() ?? '',
      tracking: json['tracking']?.toString() ?? '',
      trackingName: json['tracking_name']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderDate: json['order_date']?.toString() ?? '',
      orderTime: json['order_time']?.toString() ?? '',
      orderDeliveryData: json['order_delivery_data']?.toString() ?? '',
      orderDeliveryTime: json['order_delivery_time']?.toString() ?? '',
      cart: json['cart'] as List<dynamic>? ?? [],
      user: json['user'] as Map<String, dynamic>? ?? {},
      address: json['address'] as Map<String, dynamic>? ?? {},
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null || value == '') return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'used_coupon': usedCoupon,
      'coupon_price': couponPrice,
      'coupon_code': couponCode,
      'total_price': totalPrice,
      'products_price': productsPrice,
      'shipping': shipping,
      'tax': tax,
      'status': status,
      'status_name': statusName,
      'tracking': tracking,
      'tracking_name': trackingName,
      'payment_method': paymentMethod,
      'order_date': orderDate,
      'order_time': orderTime,
      'order_delivery_data': orderDeliveryData,
      'order_delivery_time': orderDeliveryTime,
      'cart': cart,
      'user': user,
      'address': address,
    };
  }
}
