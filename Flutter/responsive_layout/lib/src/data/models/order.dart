import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_layout/src/data/models/product.dart';

enum OrderStatus { pending, processing, shipped, delivered, canceled }

class OnlineOrder {
  final String orderId, customerId;
  final List<Product> products;
  final double totalPrice;
  final DateTime orderDate;
  OrderStatus status;

  OnlineOrder({
    required this.orderId,
    required this.customerId,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    this.status = OrderStatus.pending,
  });

  factory OnlineOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing order data for document ID: ${doc.id}');
    }

    return OnlineOrder(
      orderId: data['orderId'] ?? doc.id,
      customerId: data['customerId'] ?? '',
      products:
          (data['products'] as List<dynamic>)
              .map((e) => Product.fromFirestore(e))
              .toList(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      status: OrderStatus.values.byName(data['status'] ?? 'pending'),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'customerId': customerId,
    'products': products.map((e) => e.toFirestore()).toList(),
    'totalPrice': totalPrice,
    'orderDate': Timestamp.fromDate(orderDate),
    'status': status.name,
  };
}
