import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String address;
  final String? phoneNumber;
  final String? imageUrl;

  User({
    required this.name,
    required this.email,
    required this.address,
    this.phoneNumber,
    this.imageUrl,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data['name'] as String? ?? 'Unknown',
      email: data['email'] as String? ?? 'No email',
      address: data['address'] as String? ?? 'No address',
      phoneNumber: data['phoneNumber'] as String?,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? address,
    String? phoneNumber,
    String? imageUrl,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email, address: $address, phoneNumber: $phoneNumber, imageUrl: $imageUrl)';
  }
}
