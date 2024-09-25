import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentMethod {
  final String userId;
  final String cardNumber;
  final String cvc;
  final String cardHolderName;
  final String expireDate;

  UserPaymentMethod({
    required this.userId,
    required this.cardNumber,
    required this.cvc,
    required this.cardHolderName,
    required this.expireDate,
  });

  // Factory constructor to create a UserPaymentMethod from Firestore document snapshot
  factory UserPaymentMethod.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserPaymentMethod(
      userId: data['userId'] as String,
      cardNumber: data['cardNumber'] as String,
      cvc: data['cvc'] as String,
      cardHolderName: data['cardHolderName'] as String,
      expireDate: data['expireDate'] as String,
    );
  }

  // Convert UserPaymentMethod to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cardNumber': cardNumber,
      'cvc': cvc,
      'cardHolderName': cardHolderName,
      'expireDate': expireDate,
    };
  }

  // Factory constructor to create a UserPaymentMethod from a Map
  factory UserPaymentMethod.fromMap(Map<String, dynamic> map) {
    return UserPaymentMethod(
      userId: map['userId'] as String,
      cardNumber: map['cardNumber'] as String,
      cvc: map['cvc'] as String,
      cardHolderName: map['cardHolderName'] as String,
      expireDate: map['expireDate'] as String,
    );
  }

  @override
  String toString() {
    return 'UserPaymentMethod(userId: $userId, cardNumber: $cardNumber, cvc: $cvc, cardHolderName: $cardHolderName, expireDate: $expireDate)';
  }
}
