import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/user.payment.method.dart';

class UserPaymentMethodService {
  final CollectionReference _paymentMethodsCollection =
      FirebaseFirestore.instance.collection('user_payment_methods');

  // Add or update a payment method
  Future<void> addOrUpdatePaymentMethod(UserPaymentMethod paymentMethod) async {
    final paymentMethodRef = _paymentMethodsCollection
        .doc('${paymentMethod.userId}_${paymentMethod.cardNumber}');

    final docSnapshot = await paymentMethodRef.get();

    if (docSnapshot.exists) {
      // Update existing payment method
      await paymentMethodRef.update(paymentMethod.toMap());
    } else {
      // Create a new payment method
      await paymentMethodRef.set(paymentMethod.toMap());
    }
  }

  // Get all payment methods by userId
  Future<List<UserPaymentMethod>> getPaymentMethodsByUserId(
      String userId) async {
    final paymentMethodsQuery = await _paymentMethodsCollection
        .where('userId', isEqualTo: userId)
        .get();

    return paymentMethodsQuery.docs
        .map((doc) => UserPaymentMethod.fromDocumentSnapshot(doc))
        .toList();
  }

  // Delete a payment method
  Future<void> deletePaymentMethod(String userId, String cardNumber) async {
    final paymentMethodRef =
        _paymentMethodsCollection.doc('${userId}_${cardNumber}');

    await paymentMethodRef.delete();
  }
}
