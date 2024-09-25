import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_food_app/models/cart.model.dart';
import 'package:dog_food_app/models/product.model.dart';
import 'package:dog_food_app/services/cart.service.dart';
import 'package:dog_food_app/utils/index.dart';
import 'package:dog_food_app/views/order/place.order.view.dart';
import 'package:dog_food_app/widgets/custom.filled.button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  Product getProductById(String id) =>
      sampleProducts.firstWhere((element) => element.id == id);

  @override
  Widget build(BuildContext context) {
    final cartService = CartItemService();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("cart")
                  .where("userId", isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cartDocs = snapshot.data!.docs;

                if (cartDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    final cartItem =
                        cartDocs[index].data() as Map<String, dynamic>;
                    final productId = cartItem['itemId'] as String;
                    final quantity = cartItem['quantity'] as int;

                    final product = getProductById(productId);

                    return Dismissible(
                      key: Key(productId),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        cartService.deleteCartItem(userId!, productId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${product.name} removed from cart')),
                        );
                      },
                      child: ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          'Price: \$${product.price.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                CartItem cartItem = CartItem(
                                    userId: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "",
                                    itemId: productId,
                                    quantity: quantity);
                                if (quantity > 1) {
                                  cartService.updateCartItemQuantity(
                                      cartItem, quantity - 1);
                                }
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                CartItem cartItem = CartItem(
                                    userId: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "",
                                    itemId: productId,
                                    quantity: quantity);
                                cartService.updateCartItemQuantity(
                                    cartItem, quantity + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("cart")
                .where("userId", isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final cartDocs = snapshot.data!.docs;
              double subtotal = 0;

              for (var doc in cartDocs) {
                final cartItem = doc.data() as Map<String, dynamic>;
                final productId = cartItem['itemId'] as String;
                final quantity = cartItem['quantity'] as int;
                final product = getProductById(productId);
                subtotal += product.price * quantity;
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Checkout",
                      onPressed: () {
                        context.navigator(
                            context,
                            PlaceOrderView(
                                cartItems: cartDocs
                                    .map(
                                        (e) => CartItem.fromDocumentSnapshot(e))
                                    .toList(),
                                totalBill: subtotal));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
