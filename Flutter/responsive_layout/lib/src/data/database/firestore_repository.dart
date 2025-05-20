import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_layout/src/data/models/app_user.dart';
import 'package:responsive_layout/src/data/models/order.dart';
import 'package:responsive_layout/src/data/models/product.dart';
import 'package:responsive_layout/src/data/database/database_repository.dart';

class FirestoreDatabaseRepository implements DatabaseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> createAppUser(AppUser appUser) async {
    await firestore.collection('users').doc(appUser.customerId).set({
      'username': appUser.username,
      'deliveryStreet': appUser.deliveryStreet,
      'deliveryHouseNumber': appUser.deliveryHouseNumber,
      'deliveryZipCode': appUser.deliveryZipCode,
      'userEmail': appUser.userEmail,
      'phoneNumber': appUser.phoneNumber,
    });
  }

  @override
  Future<void> addToBasket(Product product, String userId) async {
    await firestore.collection('users').doc(userId).collection('basket').add({
      'productId': product.productId,
      'productName': product.productName,
      'productDescription': product.productDescription,
      'amountInStock': product.amountInStock,
      'productPrice': product.productPrice,
      'productSize': product.productSize.toString(),
      'releaseDate': product.releaseDate.toIso8601String(),
    });
  }

  @override
  Future<void> placeOrder(OnlineOrder order) async {
    await firestore.collection('orders').add({
      'orderId': order.orderId,
      'userId': order.customerId,
      'products': order.products.map((p) => p.productId).toList(),
      'totalPrice': order.totalPrice,
      'orderDate': order.orderDate.toIso8601String(),
    });
  }

  @override
  Future<void> addToWishlist(Product product, AppUser appUser) async {
    await firestore
        .collection('users')
        .doc(appUser.customerId)
        .collection('wishlist')
        .add({
          'productId': product.productId,
          'productName': product.productName,
          'productDescription': product.productDescription,
          'productPrice': product.productPrice,
        });
  }

  @override
  Future<List<Product>> showProducts(List<String> categories) async {
    final snapshot =
        await firestore
            .collection('products')
            .where('category', whereIn: categories)
            .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Future<List<OnlineOrder>> getOrders(String userId) async {
    final snapshot =
        await firestore
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();

    return snapshot.docs.map((doc) => OnlineOrder.fromFirestore(doc)).toList();
  }
}
