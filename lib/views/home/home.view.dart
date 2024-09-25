import 'package:dog_food_app/models/cart.model.dart';
import 'package:dog_food_app/services/cart.service.dart';
import 'package:dog_food_app/utils/index.dart';
import 'package:dog_food_app/views/cart/cart.view.dart';
import 'package:dog_food_app/views/home/single.product.view.dart';
import 'package:dog_food_app/views/profile/profile.view.dart';
import 'package:dog_food_app/widgets/app.drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog_food_app/models/product.model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Product> filteredProducts = sampleProducts;
  String searchQuery = '';
  String selectedBrand = 'All';
  String selectedType = 'All';
  String selectedAge = 'All';
  String sortBy = 'None';

  // List of filter options
  final List<String> productTypes = [
    'All',
    'Dry Food',
    'Wet Food',
    'Treats',
    'Supplement'
  ];
  final List<String> brands = [
    'All',
    'HealthyPup',
    'TastyBowl',
    'CleanTeeth',
    'MobilityPlus',
    'GoldenYears'
  ];
  final List<String> ageGroups = ['All', 'Puppy', 'Adult', 'Senior'];

  // Search and filter logic
  void searchAndFilterProducts() {
    setState(() {
      filteredProducts = sampleProducts.where((product) {
        final matchesSearch =
            product.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesBrand =
            selectedBrand == 'All' || product.brand == selectedBrand;
        final matchesType = selectedType == 'All' ||
            product.type.name == selectedType.toLowerCase();
        final matchesAge = selectedAge == 'All' ||
            product.suitableFor.contains(selectedAge.toLowerCase());

        return matchesSearch && matchesBrand && matchesType && matchesAge;
      }).toList();

      if (sortBy == 'Price: Low to High') {
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == 'Price: High to Low') {
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      } else if (sortBy == 'Rating') {
        filteredProducts
            .sort((a, b) => b.averageRating.compareTo(a.averageRating));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          "Dog Food Products",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                context.navigator(
                    context,
                    ProfileView(
                      userEmail: FirebaseAuth.instance.currentUser?.email ?? "",
                    ));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                context.navigator(context, const CartView());
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                searchQuery = value;
                searchAndFilterProducts();
              },
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Brand Dropdown
                DropdownButton<String>(
                  value: selectedBrand,
                  items: brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value!;
                      searchAndFilterProducts();
                    });
                  },
                ),
                // Type Dropdown
                DropdownButton<String>(
                  value: selectedType,
                  items: productTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      searchAndFilterProducts();
                    });
                  },
                ),
                // Age Dropdown
                DropdownButton<String>(
                  value: selectedAge,
                  items: ageGroups.map((age) {
                    return DropdownMenuItem<String>(
                      value: age,
                      child: Text(age),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAge = value!;
                      searchAndFilterProducts();
                    });
                  },
                ),
                // Sort Dropdown
                DropdownButton<String>(
                  value: sortBy,
                  items: [
                    'None',
                    'Price: Low to High',
                    'Price: High to Low',
                    'Rating'
                  ].map((sortOption) {
                    return DropdownMenuItem<String>(
                      value: sortOption,
                      child: Text(sortOption),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                      searchAndFilterProducts();
                    });
                  },
                ),
              ],
            ),
          ),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7, // Adjust based on your item design
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartItemService _cartService = CartItemService();
    return InkWell(
      onTap: () {
        context.navigator(context, SingleProductView(product: product));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  // Product Brand
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Product Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Add to Cart Button
                  IconButton(
                    onPressed: () async {
                      CartItem cartItem = CartItem(
                          userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                          itemId: product.id,
                          quantity: 1);
                      await _cartService.addOrUpdateCartItem(cartItem);
                      // Handle adding the product to the cart
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${product.name} added to cart!'),
                      ));
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
