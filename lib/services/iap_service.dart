import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'subscription_service.dart';

/// In-App Purchase Service for Moto Pro
///
/// Product IDs should match those configured in:
/// - Google Play Console (for Android)
/// - App Store Connect (for iOS)

class IAPService {
  // Singleton instance
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  // Product IDs - configure these in your store consoles
  static const String yearlyProductId = 'moto_pro_yearly';
  static const String monthlyProductId = 'moto_pro_monthly';
  static const String lifetimeProductId = 'moto_pro_lifetime';

  static final List<String> productIds = [
    yearlyProductId,
    monthlyProductId,
    lifetimeProductId,
  ];

  // Instance of InAppPurchase
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // Stream subscription for purchase updates
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Cached product details
  static final Map<String, ProductDetails> _products = {};
  static bool _isInitialized = false;
  static bool _isLoading = false;

  // Callback for purchase status updates
  Function(bool success, String? error)? onPurchaseResult;

  /// Initialize IAP and load products
  static Future<void> initialize() async {
    if (_isInitialized || _isLoading) return;
    _isLoading = true;

    try {
      final instance = IAPService();

      // Check if IAP is available
      final bool available = await instance._inAppPurchase.isAvailable();
      if (!available) {
        _isLoading = false;
        return;
      }

      // Listen to purchase updates
      instance._subscription = instance._inAppPurchase.purchaseStream.listen(
        instance._handlePurchaseUpdates,
        onDone: () => instance._subscription?.cancel(),
        onError: (error) => debugPrint('IAP Stream Error: $error'),
      );

      // Load product details
      final ProductDetailsResponse response =
          await instance._inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }

      for (final product in response.productDetails) {
        _products[product.id] = product;
      }

      _isInitialized = true;

      // Best-effort subscription lifecycle re-verification (never touches
      // habit data; only ever downgrades Pro status after a grace period).
      unawaited(_verifyLifecycle());
    } catch (e) {
      debugPrint('IAP initialization error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Silently checks whether a previously-Pro user still has an active
  /// entitlement, using [restorePurchases] as a proxy since this app has no
  /// backend receipt validation. If the store confirms nothing active and
  /// the last successful verification is older than the grace period,
  /// downgrades to free and flags a one-time, respectful notice.
  static Future<void> _verifyLifecycle() async {
    final isPro = await SubscriptionService.isPro();
    if (!isPro) return;

    bool sawActiveEntitlement = false;
    final sub = InAppPurchase.instance.purchaseStream.listen((purchases) {
      if (purchases.any(
        (p) =>
            p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored,
      )) {
        sawActiveEntitlement = true;
      }
    });

    bool restoreFailed = false;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      debugPrint('IAP lifecycle restore error: $e');
      restoreFailed = true;
    }

    await Future.delayed(const Duration(seconds: 4));
    await sub.cancel();

    if (sawActiveEntitlement) {
      await SubscriptionService.recordVerified();
      return;
    }

    // Couldn't actually ask the store (offline, store unavailable, etc.) —
    // this is inconclusive, not a confirmed loss of entitlement, so don't
    // let it burn down the grace period.
    if (restoreFailed) return;

    final lastVerified = await SubscriptionService.getLastVerifiedAt();
    if (lastVerified == null) {
      // Pre-existing Pro user from before this check existed (or the store
      // just didn't replay an event this run) — seed the clock instead of
      // treating "never verified" as "grace already expired", which would
      // downgrade them on the very first check.
      await SubscriptionService.recordVerified();
      return;
    }

    final graceExpired =
        DateTime.now().difference(lastVerified) > const Duration(days: 3);
    if (graceExpired) {
      await SubscriptionService.setPro(false);
      await SubscriptionService.flagDowngradeNotice();
    }
  }

  /// Handle purchase updates from the stream
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          // Show loading indicator
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify purchase (in production, verify with your backend)
          final valid = await _verifyPurchase(purchase);
          if (valid) {
            await SubscriptionService.setPro(true);
            await SubscriptionService.recordVerified();
            onPurchaseResult?.call(true, null);
          } else {
            onPurchaseResult?.call(false, 'Purchase verification failed');
          }
          break;

        case PurchaseStatus.error:
          onPurchaseResult?.call(false, purchase.error?.message ?? 'Purchase failed');
          break;

        case PurchaseStatus.canceled:
          onPurchaseResult?.call(false, null); // null error = user cancelled
          break;
      }

      // Complete the purchase
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  /// Verify purchase (implement server-side verification in production)
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // In production, verify the purchase with your backend server
    // For now, we trust the local verification
    return purchase.status == PurchaseStatus.purchased ||
           purchase.status == PurchaseStatus.restored;
  }

  /// Get product info by ID
  static ProductDetails? getProduct(String productId) {
    return _products[productId];
  }

  /// Get yearly product price (localized string from store)
  static String? get yearlyPrice => _products[yearlyProductId]?.price;

  /// Get monthly product price (localized string from store)
  static String? get monthlyPrice => _products[monthlyProductId]?.price;

  /// Get lifetime product price (localized string from store)
  static String? get lifetimePrice => _products[lifetimeProductId]?.price;

  /// Get raw prices for calculations
  static double? get yearlyRawPrice => _products[yearlyProductId]?.rawPrice;
  static double? get monthlyRawPrice => _products[monthlyProductId]?.rawPrice;

  /// Get currency symbol from yearly product (or any available)
  static String? get currencySymbol {
    final product = _products[yearlyProductId] ??
                    _products[monthlyProductId] ??
                    _products[lifetimeProductId];
    return product?.currencySymbol;
  }

  /// Calculate savings percentage (yearly vs 12 months of monthly)
  static int? get yearlySavingsPercent {
    final yearly = yearlyRawPrice;
    final monthly = monthlyRawPrice;
    if (yearly == null || monthly == null || monthly == 0) return null;
    final yearlyEquivalent = monthly * 12;
    final savings = ((yearlyEquivalent - yearly) / yearlyEquivalent * 100).round();
    return savings > 0 ? savings : null;
  }

  /// Get monthly equivalent price for yearly subscription (formatted like store prices)
  static String? get yearlyPerMonthPrice {
    final yearly = yearlyRawPrice;
    final product = _products[yearlyProductId];
    if (yearly == null || product == null) return null;
    final perMonth = yearly / 12;

    // Use the store's price format as a template
    // This ensures consistent decimal separators and currency position
    final storePrice = product.price; // e.g., "19,99 €" or "€19.99"
    final rawPrice = product.rawPrice; // e.g., 19.99

    // Format perMonth with 2 decimal places
    final perMonthFormatted = perMonth.toStringAsFixed(2);

    // Replace the original price number with the per-month value
    // Handle both comma and dot decimal separators
    final rawPriceStr = rawPrice.toStringAsFixed(2);
    final rawPriceComma = rawPriceStr.replaceAll('.', ',');

    // Try to replace in the store price format
    String result = storePrice;
    if (storePrice.contains(rawPriceStr)) {
      result = storePrice.replaceFirst(rawPriceStr, perMonthFormatted);
    } else if (storePrice.contains(rawPriceComma)) {
      // Store uses comma, so convert our result too
      result = storePrice.replaceFirst(rawPriceComma, perMonthFormatted.replaceAll('.', ','));
    } else {
      // Fallback: just use symbol + value
      final symbol = currencySymbol;
      if (symbol != null) {
        result = '$symbol${perMonthFormatted.replaceAll('.', ',')}';
      } else {
        result = perMonthFormatted.replaceAll('.', ',');
      }
    }

    return result;
  }

  /// Check if products are loaded
  static bool get isReady => _isInitialized && _products.isNotEmpty;

  /// Check if currently loading
  static bool get isLoading => _isLoading;

  /// Purchase a product
  static Future<bool> purchase(String productId) async {
    final product = _products[productId];
    if (product == null) {
      debugPrint('Product not found: $productId');
      return false;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    try {
      // Both subscriptions and lifetime are non-consumable
      return await IAPService()._inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }

  /// Restore purchases
  static Future<void> restorePurchases() async {
    await IAPService()._inAppPurchase.restorePurchases();
  }

  /// Dispose resources
  static void dispose() {
    IAPService()._subscription?.cancel();
  }
}
