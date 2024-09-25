import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/user.model.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Create a new user
  Future<void> createUser(User user) async {
    try {
      await _usersCollection.doc(user.email).set(user.toMap());
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  // Read a user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(email).get();
      if (doc.exists) {
        return User.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user: $e');
      rethrow;
    }
  }

  // Update a user
  Future<void> updateUser(User user) async {
    try {
      await _usersCollection.doc(user.email).update(user.toMap());
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // Delete a user
  Future<void> deleteUser(String email) async {
    try {
      await _usersCollection.doc(email).delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  // Get all users
  Stream<List<User>> getAllUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => User.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Search users by name
  Future<List<User>> searchUsersByName(String name) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThan: name + 'z')
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      rethrow;
    }
  }
}
