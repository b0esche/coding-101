import 'package:cloud_firestore/cloud_firestore.dart';

// Product Model
enum ProductSize { small, medium, large }

class Product {
  final String productID, productName, productDescription;
  final int amountInStock;
  final double productPrice;
  final ProductSize productSize;
  final DateTime releaseDate;
  final List<String> productCategories, productTags, productImages;

  bool get isAvailable => amountInStock > 0;

  Product({
    required this.productID,
    required this.productName,
    required this.productDescription,
    required this.amountInStock,
    required this.productPrice,
    required this.productSize,
    required this.releaseDate,
    required this.productCategories,
    required this.productTags,
    required this.productImages,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing product data for document ID: ${doc.id}');
    }

    return Product(
      productID: data['productId'] ?? doc.id,
      productName: data['productName'] ?? '',
      productDescription: data['productDescription'] ?? '',
      amountInStock: data['amountInStock'] ?? 0,
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      productSize: ProductSize.values.byName(data['productSize'] ?? 'small'),
      releaseDate: (data['releaseDate'] as Timestamp).toDate(),
      productCategories: List<String>.from(data['productCategories'] ?? []),
      productTags: List<String>.from(data['productTags'] ?? []),
      productImages: List<String>.from(data['productImages'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'productID': productID,
    'productName': productName,
    'productDescription': productDescription,
    'amountInStock': amountInStock,
    'productPrice': productPrice,
    'productSize': productSize.name,
    'releaseDate': Timestamp.fromDate(releaseDate),
    'productCategories': productCategories,
    'productTags': productTags,
    'productImages': productImages,
  };
}
