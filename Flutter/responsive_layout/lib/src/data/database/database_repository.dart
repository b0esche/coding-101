import 'package:responsive_layout/src/data/models/app_user.dart';
import 'package:responsive_layout/src/data/models/order.dart';
import 'package:responsive_layout/src/data/models/product.dart';

abstract class DatabaseRepository {
  Future<void> createAppUser(AppUser appUser);
  Future<void> updateAppUser(AppUser appUser, String customerId);
  Future<void> deleteAppUser(AppUser appUser, String customerId);
  Future<void> addToBasket(Product product, String customerId, String basketId);
  Future<void> removeFromBasket(
    Product product,
    String customerId,
    String basketId,
  );
  Future<void> placeOrder(OnlineOrder order);
  Future<void> addToWishlist(
    Product product,
    String customerId,
    String wishlistId,
  );
  Future<void> removeFromWishlist(
    Product product,
    String customerId,
    String wishlistId,
  );
  Future<List<Product>> getProductsByTags(List<String>? tags);
  Future<List<OnlineOrder>> getOrdersFromUser(String customerId);
}
