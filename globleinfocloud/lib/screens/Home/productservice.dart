import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference<Map<String, dynamic>> _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct({
    required String userId,
    required String name,
    required double price,
    required String type,
    required File imageFile,
    required String description,
     required String? univercity,
    required String? branch,
    required String? sem
  }) async {
    // Upload image to Firebase Storage and get download URL
    String imageUrl = await _uploadImage(imageFile,
        'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Add product details along with the image URL to Firestore
    await _productsCollection.add({
      'userId': userId,
      'name': name,
      'price': price,
      'type': type,
      'imageUrl': imageUrl,
      'description': description, 
      'univercity':univercity,
      'branch':branch,
      'sem':sem
    });
  }

  Future<String> _uploadImage(File imageFile, String imagePath) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
