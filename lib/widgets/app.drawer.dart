import 'package:dog_food_app/utils/index.dart';
import 'package:dog_food_app/views/educational/educational.content.view.dart';
import 'package:dog_food_app/views/order/order.history.view.dart';
import 'package:dog_food_app/views/profile/payment.methods.view.dart';
import 'package:dog_food_app/views/profile/profile.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              context.navigator(
                  context,
                  ProfileView(
                      userEmail:
                          FirebaseAuth.instance.currentUser?.email ?? ""));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Order History"),
            onTap: () {
              context.navigator(
                  context,
                  OrderHistoryView(
                    userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Payment Methods"),
            onTap: () {
              context.navigator(context, PaymentMethodsView());
            },
          ),
          ListTile(
            leading: Icon(Icons.video_call),
            title: Text("Blog"),
            onTap: () {
              context.navigator(context, EducationalContentView());
            },
          ),
        ],
      ),
    );
  }
}
