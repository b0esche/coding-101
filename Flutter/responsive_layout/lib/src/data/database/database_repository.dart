import 'package:responsive_layout/src/data/models/app_user.dart';
import 'package:responsive_layout/src/data/models/order.dart';
import 'package:responsive_layout/src/data/models/product.dart';

abstract class DatabaseRepository {
  Future<void> createAppUser(AppUser appUser);
  Future<void> addToBasket(Product product, String userId);
  Future<void> placeOrder(OnlineOrder order);
  Future<void> addToWishlist(Product product, AppUser appUser);
  Future<List<Product>> showProducts(List<String> categories);
  Future<List<OnlineOrder>> getOrders(String userId);
}
