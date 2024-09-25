import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String userId;
  final String itemId;
  int quantity;

  CartItem({
    required this.userId,
    required this.itemId,
    required this.quantity,
  });

  // Factory constructor to create a CartItem from Firestore document snapshot
  factory CartItem.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CartItem(
      userId: data['userId'] as String,
      itemId: data['itemId'] as String,
      quantity: data['quantity'] as int,
    );
  }

  // Convert CartItem to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemId': itemId,
      'quantity': quantity,
    };
  }

// Factory constructor to create a CartItem from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      userId: map['userId'] as String,
      itemId: map['itemId'] as String,
      quantity: map['quantity'] as int,
    );
  }
  @override
  String toString() {
    return 'CartItem(userId: $userId, itemId: $itemId, quantity: $quantity)';
  }
}
