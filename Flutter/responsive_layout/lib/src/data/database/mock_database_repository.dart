import 'package:responsive_layout/src/data/database/database_repository.dart';
import 'package:responsive_layout/src/data/models/app_user.dart';
import 'package:responsive_layout/src/data/models/order.dart';
import 'package:responsive_layout/src/data/models/product.dart';

class MockDatabaseRepository implements DatabaseRepository {
  final List<Product> mockProducts = [
    Product(
      productId: 'p001',
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
      productId: 'p002',
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
      productId: 'p003',
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
      productId: 'p004',
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
      productId: 'p005',
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
      productId: 'p006',
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
      productId: 'p007',
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
      productId: 'p008',
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
  Future<void> createAppUser(AppUser appUser) async {
    print('Mock: Benutzer ${appUser.username} angelegt.');
  }

  @override
  Future<void> addToBasket(Product product, String userId) async {
    print(
      'Mock: ${product.productName} zum Warenkorb von $userId hinzugefügt.',
    );
  }

  @override
  Future<void> placeOrder(OnlineOrder order) async {
    _mockOrders.add(order);
    print('Mock: Bestellung ${order.orderId} gespeichert.');
  }

  @override
  Future<void> addToWishlist(Product product, AppUser appUser) async {
    print('Mock: ${product.productName} zur Wishlist von ${appUser.username}.');
  }

  @override
  Future<List<Product>> showProducts(List<String> categories) async {
    return mockProducts
        .where((p) => p.productCategories.any(categories.contains))
        .toList();
  }

  @override
  Future<List<OnlineOrder>> getOrders(String userId) async {
    return _mockOrders;
  }
}
