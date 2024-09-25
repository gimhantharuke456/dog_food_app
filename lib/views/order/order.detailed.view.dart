import 'package:dog_food_app/models/cart.model.dart';
import 'package:dog_food_app/models/order.model.dart';
import 'package:dog_food_app/models/product.review.dart';
import 'package:dog_food_app/services/product.review.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id.substring(0, 8)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Order Details'),
            _buildDetailRow('Order ID', order.id),
            _buildDetailRow(
                'Date', DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt)),
            _buildDetailRow(
                'Total Bill', '\$${order.totalBill.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            _buildSectionTitle('Receiver Information'),
            _buildDetailRow('Name', order.receiverName),
            _buildDetailRow('Email', order.receiverEmail),
            _buildDetailRow('Phone', order.receiverPhone),
            _buildDetailRow('Address', order.address),
            const SizedBox(height: 16),
            _buildSectionTitle('Ordered Items'),
            ...order.orderedItems
                .map((item) => _buildOrderedItem(context, item))
                .toList(),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildOrderedItem(BuildContext context, CartItem item) {
    return ListTile(
      title: Text(item.itemId),
      subtitle: Text('Quantity: ${item.quantity}'),
      trailing: IconButton(
        icon: Icon(Icons.rate_review),
        onPressed: () => _showReviewDialog(context, item),
      ),
    );
  }

  // Method to show a dialog for review input
  Future<void> _showReviewDialog(BuildContext context, CartItem item) async {
    final TextEditingController reviewController = TextEditingController();
    int numOfStars = 3;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Review ${item.itemId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  hintText: 'Enter your review',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<int>(
                value: numOfStars,
                onChanged: (value) {
                  numOfStars = value!;
                  (context as Element).markNeedsBuild(); // To rebuild dialog
                },
                items: List.generate(5, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1} Star${index > 0 ? 's' : ''}'),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _submitReview(
                    context, item.itemId, reviewController.text, numOfStars);
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReview(BuildContext context, String itemId,
      String reviewText, int numOfStars) async {
    // Assume the userId is available from the app's auth state.
    final String reviewerId = 'sampleUserId'; // Replace with actual user ID

    final review = ProductReview(
      productId: itemId,
      review: reviewText,
      reviewerId: reviewerId,
      numOfStars: numOfStars,
    );

    final productReviewService = ProductReviewService();
    await productReviewService.addOrUpdateReview(review);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );
  }
}
