import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String imageUrl;
  final String name;
  final double price;
  final String type;
  final String userId;
  final String description;
  final String id;
  final String univercity;
  final String branch;
  final String sem;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.type,
    required this.userId,
    required this.description,
    required this.id,
    required this.univercity,
    required this.branch,
    required this.sem
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      type: data['type'] ?? '',
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      univercity: data['univercity'] ?? '',
      branch: data['branch'] ?? '',
      sem: data['sem'] ?? ''
    );
  }
}