import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/cart.model.dart';

class CartItemService {
  Future<void> addOrUpdateCartItem(CartItem cartItem) async {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .doc('${cartItem.userId}_${cartItem.itemId}');

    // Check if the item already exists
    final docSnapshot = await cartRef.get();
    if (docSnapshot.exists) {
      // If exists, update the quantity
      final currentQuantity =
          (docSnapshot.data() as Map<String, dynamic>)['quantity'] as int;
      await cartRef.update({
        'quantity': currentQuantity + cartItem.quantity,
      });
    } else {
      // If not exists, create a new cart item
      await cartRef.set(cartItem.toMap());
    }
  }

  Future<void> clearCart(String userId) async {
    final cartQuery = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in cartQuery.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<List<CartItem>> getCartItemsByUser(String userId) async {
    final cartQuery = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();

    return cartQuery.docs
        .map((doc) => CartItem.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<void> updateCartItemQuantity(
      CartItem cartItem, int newQuantity) async {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .doc('${cartItem.userId}_${cartItem.itemId}');

    await cartRef.update({
      'quantity': newQuantity,
    });
  }

  Future<void> deleteCartItem(String userId, String itemId) async {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .doc('${userId}_${itemId}');

    await cartRef.delete();
  }
}
