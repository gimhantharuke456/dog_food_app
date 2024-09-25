enum ProductType { dryFood, wetFood, treats, supplement }

class Product {
  final String id;
  final String name;
  final String brand;
  final ProductType type;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> suitableFor; // e.g., ["puppy", "adult", "senior"]
  final List<String> ingredients;
  final Map<String, String> nutritionalInfo;

  double averageRating;
  int numberOfReviews;

  set setAverageRating(double avg) => averageRating = avg;
  set setNumOfReviews(int num) => numberOfReviews = num;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.suitableFor,
    required this.ingredients,
    required this.nutritionalInfo,
    this.averageRating = 0.0,
    this.numberOfReviews = 0,
  });
}

// Sample product list
List<Product> sampleProducts = [
  Product(
    id: "DF001",
    name: "Premium Puppy Kibble",
    brand: "HealthyPup",
    type: ProductType.dryFood,
    description:
        "Nutritionally complete dry food for growing puppies. Rich in proteins and essential nutrients for healthy development.",
    price: 29.99,
    imageUrl:
        "https://bestcarepetshop.lk/web/image/product.image/129/image_1024/Premium%20Dog%20Food%20Puppy%2010Kg?unique=1b476eb",
    suitableFor: ["puppy"],
    ingredients: [
      "Chicken",
      "Brown Rice",
      "Vegetables",
      "Fish Oil",
      "Vitamins"
    ],
    nutritionalInfo: {
      "Protein": "28%",
      "Fat": "15%",
      "Fiber": "3%",
      "Moisture": "10%",
    },
  ),
  Product(
    id: "WF001",
    name: "Gourmet Beef Stew",
    brand: "TastyBowl",
    type: ProductType.wetFood,
    description:
        "Delicious wet food made with real beef chunks in a savory gravy. Perfect for adult dogs of all breeds.",
    price: 2.49,
    imageUrl:
        "https://www.gordonrhodes.co.uk/wp-content/uploads/Traditional-Beef-Stew-Slow-Comfortable-Stew-768x754.jpg",
    suitableFor: ["adult"],
    ingredients: ["Beef", "Chicken Broth", "Carrots", "Peas", "Potatoes"],
    nutritionalInfo: {
      "Protein": "8%",
      "Fat": "6%",
      "Fiber": "1.5%",
      "Moisture": "78%",
    },
  ),
  Product(
    id: "TR001",
    name: "Dental Chew Sticks",
    brand: "CleanTeeth",
    type: ProductType.treats,
    description:
        "Delicious treats that help clean your dog's teeth and freshen breath. Suitable for all adult dogs.",
    price: 14.99,
    imageUrl:
        "https://ubavet.com/wp-content/uploads/2023/01/uabdent_chewsticks_18.jpg",
    suitableFor: ["adult", "senior"],
    ingredients: [
      "Rice Flour",
      "Chicken By-Product Meal",
      "Wheat Starch",
      "Glycerin"
    ],
    nutritionalInfo: {
      "Protein": "12%",
      "Fat": "2%",
      "Fiber": "5%",
      "Moisture": "12%",
    },
  ),
  Product(
    id: "SP001",
    name: "Joint Health Supplement",
    brand: "MobilityPlus",
    type: ProductType.supplement,
    description:
        "Powder supplement to support joint health and mobility in older dogs.",
    price: 34.99,
    imageUrl: "https://vader-prod.s3.amazonaws.com/1687555950-81-YYefiGaL.jpg",
    suitableFor: ["adult", "senior"],
    ingredients: ["Glucosamine", "Chondroitin", "MSM", "Omega-3 Fatty Acids"],
    nutritionalInfo: {
      "Glucosamine": "500mg",
      "Chondroitin": "200mg",
      "MSM": "100mg",
      "Omega-3": "50mg",
    },
  ),
  Product(
    id: "DF002",
    name: "Senior Dog Formula",
    brand: "GoldenYears",
    type: ProductType.dryFood,
    description:
        "Specially formulated dry food for senior dogs. Lower in calories and enriched with joint-supporting nutrients.",
    price: 32.99,
    imageUrl:
        "https://i5.walmartimages.com/seo/Pure-Balance-Pro-Senior-Salmon-Brown-Rice-Recipe-Dry-Dog-Food-8-lbs_13b056b0-e54f-4422-808e-108792c40624.d0c4295827840147360d3fa69eada574.jpeg",
    suitableFor: ["senior"],
    ingredients: [
      "Chicken Meal",
      "Brown Rice",
      "Peas",
      "Flaxseed",
      "Glucosamine"
    ],
    nutritionalInfo: {
      "Protein": "24%",
      "Fat": "10%",
      "Fiber": "4%",
      "Moisture": "10%",
    },
  ),
];
