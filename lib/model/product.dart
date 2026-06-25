class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final double rating;
  final int reviews;
  final String image;
  final String category;
  final int inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.category,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      image: json['image'] as String,
      category: json['category'] as String,
      inStock: json['inStock'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'image': image,
      'category': category,
      'inStock': inStock,
    };
  }
}