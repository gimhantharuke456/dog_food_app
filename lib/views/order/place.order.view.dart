import 'package:dog_food_app/models/cart.model.dart';
import 'package:dog_food_app/models/order.model.dart';
import 'package:dog_food_app/services/cart.service.dart';
import 'package:dog_food_app/services/order.service.dart';
import 'package:dog_food_app/widgets/custom.filled.button.dart';
import 'package:dog_food_app/widgets/custom.input.field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaceOrderView extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalBill;

  const PlaceOrderView({
    Key? key,
    required this.cartItems,
    required this.totalBill,
  }) : super(key: key);

  @override
  _PlaceOrderViewState createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                Text('Total Items: ${widget.cartItems.length}'),
                Text('Total Bill: \$${widget.totalBill.toStringAsFixed(2)}'),
                const SizedBox(height: 24),
                Text(
                  'Delivery Information',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: "Full Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: "Email",
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: "Phone Number",
                  inputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _addressController,
                  label: 'Delivery Address',
                  hint: "Delivery Address",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Place Order',
                  onPressed: _placeOrder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final orderService = OrderService();
      final cartItemService = CartItemService();
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final newOrder = Order(
        id: '',
        userId: userId,
        createdAt: DateTime.now(),
        totalBill: widget.totalBill,
        orderedItems: widget.cartItems,
        address: _addressController.text,
        receiverName: _nameController.text,
        receiverEmail: _emailController.text,
        receiverPhone: _phoneController.text,
      );

      try {
        await orderService.createOrder(newOrder);
        await cartItemService.clearCart(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );
        // Navigate back to the cart or to an order confirmation page
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    }
  }
}
