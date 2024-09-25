import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/product.review.dart';

class ProductReviewService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('product_reviews');

  // Add or update a review
  Future<void> addOrUpdateReview(ProductReview review) async {
    final reviewRef =
        _reviewsCollection.doc('${review.productId}_${review.reviewerId}');

    final docSnapshot = await reviewRef.get();

    if (docSnapshot.exists) {
      // Update existing review
      await reviewRef.update(review.toMap());
    } else {
      // Create a new review
      await reviewRef.set(review.toMap());
    }
  }

  // Get all reviews by productId
  Future<List<ProductReview>> getReviewsByProductId(String productId) async {
    final reviewsQuery =
        await _reviewsCollection.where('productId', isEqualTo: productId).get();

    return reviewsQuery.docs
        .map((doc) => ProductReview.fromDocumentSnapshot(doc))
        .toList();
  }

  // Delete a review
  Future<void> deleteReview(String productId, String reviewerId) async {
    final reviewRef = _reviewsCollection.doc('${productId}_${reviewerId}');

    await reviewRef.delete();
  }
}
