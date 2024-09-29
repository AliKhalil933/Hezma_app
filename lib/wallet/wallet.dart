class Wallet {
  bool? status;
  String? message;
  String? wallet;
  List<dynamic>? walletActions;

  Wallet({this.status, this.message, this.wallet, this.walletActions});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        wallet: json['wallet'] as String?,
        walletActions: json['wallet_actions'] as List<dynamic>?,
      );

  get balance => null;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'wallet': wallet,
        'wallet_actions': walletActions,
      };
}
