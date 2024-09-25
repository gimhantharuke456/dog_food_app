import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/order.model.dart' as o;

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  // Create a new order
  Future<String> createOrder(o.Order order) async {
    final docRef = await _ordersCollection.add(order.toMap());
    return docRef.id;
  }

  // Read an order by ID
  Future<o.Order?> getOrderById(String orderId) async {
    final docSnapshot = await _ordersCollection.doc(orderId).get();
    if (docSnapshot.exists) {
      return o.Order.fromDocumentSnapshot(docSnapshot);
    }
    return null;
  }

  // Update an order
  Future<void> updateOrder(o.Order order) async {
    await _ordersCollection.doc(order.id).update(order.toMap());
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    await _ordersCollection.doc(orderId).delete();
  }

  // Get orders by user ID
  Stream<List<o.Order>> getOrdersByUserId(String userId) {
    return _ordersCollection.where('userId', isEqualTo: userId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => o.Order.fromDocumentSnapshot(doc))
            .toList());
  }

  // Get all orders (you might want to limit this or add pagination for large datasets)
  Stream<List<o.Order>> getAllOrders() {
    return _ordersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => o.Order.fromDocumentSnapshot(doc))
            .toList());
  }
}
