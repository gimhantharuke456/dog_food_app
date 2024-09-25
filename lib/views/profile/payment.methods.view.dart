import 'package:dog_food_app/models/user.payment.method.dart';
import 'package:dog_food_app/services/user.payment.method.service.dart';

import 'package:flutter/material.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key});

  @override
  _PaymentMethodsViewState createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  final UserPaymentMethodService _paymentMethodService =
      UserPaymentMethodService();
  late Future<List<UserPaymentMethod>> _paymentMethodsFuture;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    _paymentMethodsFuture = _paymentMethodService.getPaymentMethodsByUserId(
        'USER_ID'); // Replace 'USER_ID' with actual user id
  }

  Future<void> _addPaymentMethod(UserPaymentMethod paymentMethod) async {
    await _paymentMethodService.addOrUpdatePaymentMethod(paymentMethod);
    setState(() {
      _loadPaymentMethods();
    });
  }

  Future<void> _deletePaymentMethod(String cardNumber) async {
    await _paymentMethodService.deletePaymentMethod(
        'USER_ID', cardNumber); // Replace 'USER_ID' with actual user id
    setState(() {
      _loadPaymentMethods();
    });
  }

  void _showAddPaymentMethodDialog() {
    String cardNumber = '';
    String cvc = '';
    String cardHolderName = '';
    String expireDate = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Card Number'),
              onChanged: (value) => cardNumber = value,
              maxLength: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CVC'),
              onChanged: (value) => cvc = value,
              maxLength: 3,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Card Holder Name'),
              onChanged: (value) => cardHolderName = value,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
              onChanged: (value) => expireDate = value,
              maxLength: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newPaymentMethod = UserPaymentMethod(
                userId: 'USER_ID', // Replace 'USER_ID' with actual user id
                cardNumber: cardNumber,
                cvc: cvc,
                cardHolderName: cardHolderName,
                expireDate: expireDate,
              );
              _addPaymentMethod(newPaymentMethod);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPaymentMethodDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<UserPaymentMethod>>(
        future: _paymentMethodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load payment methods'));
          }

          final paymentMethods = snapshot.data ?? [];

          if (paymentMethods.isEmpty) {
            return const Center(child: Text('No payment methods available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              final paymentMethod = paymentMethods[index];
              return Card(
                child: ListTile(
                  title: Text(
                      '${paymentMethod.cardHolderName} - ${paymentMethod.cardNumber}'),
                  subtitle: Text('Expires: ${paymentMethod.expireDate}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        _deletePaymentMethod(paymentMethod.cardNumber),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
