import 'package:dog_food_app/models/cart.model.dart';
import 'package:dog_food_app/models/product.review.dart';
import 'package:dog_food_app/services/cart.service.dart';
import 'package:dog_food_app/services/product.review.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog_food_app/models/product.model.dart';

class SingleProductView extends StatefulWidget {
  final Product product;
  const SingleProductView({super.key, required this.product});

  @override
  _SingleProductViewState createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  double averageRating = 0.0;
  int numberOfReviews = 0;
  List<ProductReview> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadProductReviews();
  }

  // Fetch reviews and update the state
  Future<void> _loadProductReviews() async {
    List<ProductReview> fetchedReviews =
        await ProductReviewService().getReviewsByProductId(widget.product.id);

    if (fetchedReviews.isNotEmpty) {
      setState(() {
        reviews = fetchedReviews;
        numberOfReviews = reviews.length;
        averageRating = _calculateAverageRating(reviews);
      });
    }
  }

  // Calculate the average rating from the list of reviews
  double _calculateAverageRating(List<ProductReview> reviews) {
    double totalRating =
        reviews.fold(0, (sum, review) => sum + review.numOfStars);
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Product Title and Price
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Suitable For Section
            _buildSectionTitle('Suitable For'),
            _buildInfoRow(
                'Suitable for:', widget.product.suitableFor.join(', ')),

            const SizedBox(height: 16),

            // Ingredients Section
            _buildSectionTitle('Ingredients'),
            Text(
              widget.product.ingredients.join(', '),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Nutritional Info Section
            _buildSectionTitle('Nutritional Information'),
            ...widget.product.nutritionalInfo.entries
                .map((entry) => _buildInfoRow(entry.key, entry.value))
                .toList(),

            const SizedBox(height: 16),

            // Ratings and Reviews
            _buildSectionTitle('Ratings'),
            _buildInfoRow('Average Rating', averageRating.toStringAsFixed(1)),
            _buildInfoRow('Number of Reviews', numberOfReviews.toString()),

            const SizedBox(height: 16),

            // Add to Cart Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _addToCart(context, widget.product);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Collapsible Reviews Section
            _buildSectionTitle('Customer Reviews'),
            reviews.isNotEmpty
                ? _buildReviewSection() // Show reviews when they exist
                : const Center(
                    child: Text('No reviews yet.'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Product product) async {
    CartItem cartItem = CartItem(
        userId: FirebaseAuth.instance.currentUser?.uid ?? "",
        itemId: product.id,
        quantity: 1);

    await CartItemService().addOrUpdateCartItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart!')),
    );
  }

  // Build Review Section
  Widget _buildReviewSection() {
    return ExpansionTile(
      title: Text('Reviews ($numberOfReviews)'),
      initiallyExpanded: false,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            ProductReview review = reviews[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(review.numOfStars.toString()),
              ),
              title: Text(review.review),
              subtitle: Text('Reviewer: ${review.reviewerId}'),
            );
          },
        ),
      ],
    );
  }
}
