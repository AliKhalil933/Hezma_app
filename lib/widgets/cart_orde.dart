import 'package:flutter/material.dart';
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';

class CustomCard22 extends StatelessWidget {
  final ModelcartDetails order;
  final VoidCallback onCancel;
  final VoidCallback onTrack;

  const CustomCard22({
    super.key,
    required this.order,
    required this.onCancel,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('طلب رقم: ${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('السعر الكلي: ${order.totalPrice}'),
            // عرض تفاصيل أخرى حسب الحاجة
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: onCancel,
            ),
            IconButton(
              icon: const Icon(Icons.track_changes),
              onPressed: onTrack,
            ),
          ],
        ),
      ),
    );
  }
}
