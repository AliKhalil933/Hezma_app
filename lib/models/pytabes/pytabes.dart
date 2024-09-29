import 'customer_details.dart';
import 'shipping_details.dart';

class Pytabes {
  String? tranRef;
  String? tranType;
  String? cartId;
  String? cartDescription;
  String? cartCurrency;
  String? cartAmount;
  String? tranTotal;
  String? callback;
  String? pytabesReturn;
  String? redirectUrl;
  CustomerDetails? customerDetails;
  ShippingDetails? shippingDetails;
  int? serviceId;
  int? profileId;
  int? merchantId;
  String? trace;

  Pytabes({
    this.tranRef,
    this.tranType,
    this.cartId,
    this.cartDescription,
    this.cartCurrency,
    this.cartAmount,
    this.tranTotal,
    this.callback,
    this.pytabesReturn,
    this.redirectUrl,
    this.customerDetails,
    this.shippingDetails,
    this.serviceId,
    this.profileId,
    this.merchantId,
    this.trace,
  });

  factory Pytabes.fromJson(Map<String, dynamic> json) => Pytabes(
        tranRef: json['tran_ref'] as String?,
        tranType: json['tran_type'] as String?,
        cartId: json['cart_id'] as String?,
        cartDescription: json['cart_description'] as String?,
        cartCurrency: json['cart_currency'] as String?,
        cartAmount: json['cart_amount'] as String?,
        tranTotal: json['tran_total'] as String?,
        callback: json['callback'] as String?,
        pytabesReturn: json['return'] as String?,
        redirectUrl: json['redirect_url'] as String?,
        customerDetails: json['customer_details'] == null
            ? null
            : CustomerDetails.fromJson(
                json['customer_details'] as Map<String, dynamic>),
        shippingDetails: json['shipping_details'] == null
            ? null
            : ShippingDetails.fromJson(
                json['shipping_details'] as Map<String, dynamic>),
        serviceId: json['serviceId'] as int?,
        profileId: json['profileId'] as int?,
        merchantId: json['merchantId'] as int?,
        trace: json['trace'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'tran_ref': tranRef,
        'tran_type': tranType,
        'cart_id': cartId,
        'cart_description': cartDescription,
        'cart_currency': cartCurrency,
        'cart_amount': cartAmount,
        'tran_total': tranTotal,
        'callback': callback,
        'return': pytabesReturn,
        'redirect_url': redirectUrl,
        'customer_details': customerDetails?.toJson(),
        'shipping_details': shippingDetails?.toJson(),
        'serviceId': serviceId,
        'profileId': profileId,
        'merchantId': merchantId,
        'trace': trace,
      };
}
