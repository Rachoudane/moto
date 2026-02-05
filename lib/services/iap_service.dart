/// In-App Purchase Service for Moto Pro
///
/// Product IDs should match those configured in:
/// - Google Play Console (for Android)
/// - App Store Connect (for iOS)

class IAPService {
  // Product IDs - configure these in your store consoles
  static const String yearlyProductId = 'moto_pro_yearly';
  static const String monthlyProductId = 'moto_pro_monthly';
  static const String lifetimeProductId = 'moto_pro_lifetime';

  static final List<String> productIds = [
    yearlyProductId,
    monthlyProductId,
    lifetimeProductId,
  ];

  // Cached product details (prices from store)
  static Map<String, ProductInfo> _products = {};
  static bool _isInitialized = false;
  static bool _isLoading = false;

  /// Initialize IAP and load products
  static Future<void> initialize() async {
    if (_isInitialized || _isLoading) return;
    _isLoading = true;

    try {
      // TODO: Implement with in_app_purchase package
      //
      // final bool available = await InAppPurchase.instance.isAvailable();
      // if (!available) {
      //   _isLoading = false;
      //   return;
      // }
      //
      // final ProductDetailsResponse response =
      //     await InAppPurchase.instance.queryProductDetails(productIds.toSet());
      //
      // for (final product in response.productDetails) {
      //   _products[product.id] = ProductInfo(
      //     id: product.id,
      //     price: product.price,
      //     rawPrice: product.rawPrice,
      //     currencyCode: product.currencyCode,
      //   );
      // }

      _isInitialized = true;
    } catch (e) {
      // Handle initialization error
    } finally {
      _isLoading = false;
    }
  }

  /// Get product info by ID
  static ProductInfo? getProduct(String productId) {
    return _products[productId];
  }

  /// Get yearly product price (localized string from store)
  static String? get yearlyPrice => _products[yearlyProductId]?.price;

  /// Get monthly product price (localized string from store)
  static String? get monthlyPrice => _products[monthlyProductId]?.price;

  /// Get lifetime product price (localized string from store)
  static String? get lifetimePrice => _products[lifetimeProductId]?.price;

  /// Check if products are loaded
  static bool get isReady => _isInitialized && _products.isNotEmpty;

  /// Check if currently loading
  static bool get isLoading => _isLoading;

  /// Purchase a product
  static Future<bool> purchase(String productId) async {
    // TODO: Implement with in_app_purchase package
    //
    // final product = _products[productId];
    // if (product == null) return false;
    //
    // final PurchaseParam purchaseParam = PurchaseParam(
    //   productDetails: product.details,
    // );
    //
    // if (productId == lifetimeProductId) {
    //   return InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // } else {
    //   return InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // }

    return false;
  }

  /// Restore purchases
  static Future<void> restorePurchases() async {
    // TODO: Implement with in_app_purchase package
    // await InAppPurchase.instance.restorePurchases();
  }
}

/// Product information from the store
class ProductInfo {
  final String id;
  final String price; // Localized price string (e.g., "$9.99", "9,99 €")
  final double rawPrice; // Raw price value
  final String currencyCode; // e.g., "USD", "EUR"

  const ProductInfo({
    required this.id,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });
}
