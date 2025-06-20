import 'package:responsive_layout/src/data/database/database_repository.dart';
import 'package:responsive_layout/src/data/models/app_user.dart';
import 'package:responsive_layout/src/data/models/order.dart';
import 'package:responsive_layout/src/data/models/product.dart';

class MockDatabaseRepository implements DatabaseRepository {
  final List<Product> mockProducts = [
    Product(
      productID: 'p001',
      productName: 'Classic White T-Shirt',
      productDescription: 'Bequemes Basic-Shirt aus Bio-Baumwolle.',
      amountInStock: 42,
      productPrice: 19.99,
      productSize: ProductSize.medium,
      releaseDate: DateTime(2023, 3, 10),
      productCategories: ['clothing', 'tshirt'],
      productTags: ['basic', 'white', 'unisex'],
      productImages: ['https://picsum.photos/300/200'],
    ),
    Product(
      productID: 'p002',
      productName: 'Sneaker X100',
      productDescription: 'Modischer Sneaker mit atmungsaktivem Mesh.',
      amountInStock: 20,
      productPrice: 89.99,
      productSize: ProductSize.large,
      releaseDate: DateTime(2023, 6, 25),
      productCategories: ['shoes', 'sneaker'],
      productTags: ['running', 'sport', 'mesh'],
      productImages: ['https://picsum.photos/301/201'],
    ),
    Product(
      productID: 'p003',
      productName: 'Vintage Jeans',
      productDescription: 'Klassische Jeans mit leichter Waschung.',
      amountInStock: 15,
      productPrice: 59.99,
      productSize: ProductSize.medium,
      releaseDate: DateTime(2022, 11, 5),
      productCategories: ['clothing', 'jeans'],
      productTags: ['vintage', 'denim'],
      productImages: ['https://picsum.photos/302/202'],
    ),
    Product(
      productID: 'p004',
      productName: 'Eco Hoodie',
      productDescription: 'Nachhaltiger Hoodie aus recyceltem Material.',
      amountInStock: 25,
      productPrice: 49.99,
      productSize: ProductSize.large,
      releaseDate: DateTime(2024, 2, 14),
      productCategories: ['clothing', 'hoodie'],
      productTags: ['eco', 'sustainable'],
      productImages: ['https://picsum.photos/303/203'],
    ),
    Product(
      productID: 'p005',
      productName: 'Leather Wallet',
      productDescription: 'Kompaktes Portemonnaie aus Echtleder.',
      amountInStock: 30,
      productPrice: 34.50,
      productSize: ProductSize.small,
      releaseDate: DateTime(2023, 8, 8),
      productCategories: ['accessories'],
      productTags: ['leather', 'wallet', 'men'],
      productImages: ['https://picsum.photos/304/204'],
    ),
    Product(
      productID: 'p006',
      productName: 'Running Shorts',
      productDescription: 'Leichte Laufshorts mit Schweiß-Management.',
      amountInStock: 18,
      productPrice: 27.80,
      productSize: ProductSize.medium,
      releaseDate: DateTime(2024, 1, 20),
      productCategories: ['clothing', 'sports'],
      productTags: ['running', 'lightweight'],
      productImages: ['https://picsum.photos/305/205'],
    ),
    Product(
      productID: 'p007',
      productName: 'Smartwatch Band',
      productDescription: 'Ersatzband für Smartwatches, größenverstellbar.',
      amountInStock: 50,
      productPrice: 12.90,
      productSize: ProductSize.small,
      releaseDate: DateTime(2024, 5, 1),
      productCategories: ['accessories', 'tech'],
      productTags: ['watch', 'band', 'tech'],
      productImages: ['https://picsum.photos/306/206'],
    ),
    Product(
      productID: 'p008',
      productName: 'Kaffeebecher Thermo',
      productDescription: 'Doppelwandiger Edelstahlbecher, hält 12h warm.',
      amountInStock: 35,
      productPrice: 22.95,
      productSize: ProductSize.large,
      releaseDate: DateTime(2024, 4, 18),
      productCategories: ['home', 'kitchen'],
      productTags: ['coffee', 'insulated', 'travel'],
      productImages: ['https://picsum.photos/307/207'],
    ),
  ];
  final List<OnlineOrder> _mockOrders = [];

  @override
  Future<void> deleteAppUser(AppUser appUser, String customerId) {
    // TODO: implement deleteAppUser
    throw UnimplementedError();
  }

  @override
  Future<List<OnlineOrder>> getOrdersFromUser(String customerId) {
    // TODO: implement getOrdersFromUser
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByTags(List<String>? tags) {
    // TODO: implement getProductsByTags
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromBasket(
    Product product,
    String customerId,
    String basketId,
  ) {
    // TODO: implement removeFromBasket
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromWishlist(
    Product product,
    String customerId,
    String wishlistId,
  ) {
    // TODO: implement removeFromWishlist
    throw UnimplementedError();
  }

  @override
  Future<void> updateAppUser(AppUser appUser, String customerId) {
    // TODO: implement updateAppUser
    throw UnimplementedError();
  }

  @override
  Future<void> addToBasket(
    Product product,
    String customerId,
    String basketId,
  ) {
    // TODO: implement addToBasket
    throw UnimplementedError();
  }

  @override
  Future<void> addToWishlist(
    Product product,
    String customerId,
    String wishlistId,
  ) {
    // TODO: implement addToWishlist
    throw UnimplementedError();
  }

  @override
  Future<void> createAppUser(AppUser appUser) {
    // TODO: implement createAppUser
    throw UnimplementedError();
  }

  @override
  Future<void> placeOrder(OnlineOrder order) {
    // TODO: implement placeOrder
    throw UnimplementedError();
  }
}
