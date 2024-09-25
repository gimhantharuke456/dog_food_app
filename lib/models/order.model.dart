import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/cart.model.dart';

class Order {
  final String id;
  final String userId;
  final DateTime createdAt;
  final double totalBill;
  final List<CartItem> orderedItems;
  final String address;
  final String receiverName;
  final String receiverEmail;
  final String receiverPhone;

  Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.totalBill,
    required this.orderedItems,
    required this.address,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverPhone,
  });

  factory Order.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Order(
      id: snapshot.id,
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      totalBill: (data['totalBill'] as num).toDouble(),
      orderedItems: (data['orderedItems'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      address: data['address'] as String,
      receiverName: data['receiverName'] as String,
      receiverEmail: data['receiverEmail'] as String,
      receiverPhone: data['receiverPhone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalBill': totalBill,
      'orderedItems': orderedItems.map((item) => item.toMap()).toList(),
      'address': address,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverPhone': receiverPhone,
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, createdAt: $createdAt, totalBill: $totalBill, '
        'orderedItems: $orderedItems, address: $address, receiverName: $receiverName, '
        'receiverEmail: $receiverEmail, receiverPhone: $receiverPhone)';
  }
}
