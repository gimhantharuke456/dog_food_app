import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReview {
  final String productId;
  final String review;
  final String reviewerId;
  final int numOfStars;

  ProductReview({
    required this.productId,
    required this.review,
    required this.reviewerId,
    required this.numOfStars,
  });

  // Factory constructor to create a ProductReview from Firestore document snapshot
  factory ProductReview.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductReview(
      productId: data['productId'] as String,
      review: data['review'] as String,
      reviewerId: data['reviewerId'] as String,
      numOfStars: data['numOfStars'] as int,
    );
  }

  // Convert ProductReview to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'review': review,
      'reviewerId': reviewerId,
      'numOfStars': numOfStars,
    };
  }

  // Factory constructor to create a ProductReview from a Map
  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      productId: map['productId'] as String,
      review: map['review'] as String,
      reviewerId: map['reviewerId'] as String,
      numOfStars: map['numOfStars'] as int,
    );
  }

  @override
  String toString() {
    return 'ProductReview(productId: $productId, review: $review, reviewerId: $reviewerId, numOfStars: $numOfStars)';
  }
}
