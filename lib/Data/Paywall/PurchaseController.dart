import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseController {
  bool hasPro() {
    return false;
  }

  Future<bool> purchase() async {
    _processing = true;
    await Future.delayed(Duration(seconds: 2));
    _processing = false;
    return true;
  }

  bool _processing = false;

  // Getter for all sessions
  bool get processing => _processing;

  Future<List<ProductDetails>> getSubscriptionDetails() async {
    print("Loading Subscriptions");
    /*final product11 = ProductDetails(
      id: "study_pro_1",
      title: "Study Pro Plan",
      description: "Unlock all features and remove penalties.",
      price: "\$4.99",
      rawPrice: 4.99,
      currencyCode: "USD",
    );

    final product22 = ProductDetails(
      id: "focus_plus_yearly",
      title: "Focus+ Yearly Plan",
      description:
          "Get a full year of Focus+ benefits, including extra study time and penalty reductions.",
      price: "\$39.99",
      rawPrice: 39.99,
      currencyCode: "USD",
    );
*/
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      print('In-App-Käufe sind nicht verfügbar');
      throw ("Not avaibvle");
    } else {
      print("Avaible");
    }
    //, 'swipeartPremiumAnnual'
    const Set<String> kIds = {'IronHabitPremiumMonth'};
    final ProductDetailsResponse response = await InAppPurchase.instance
        .queryProductDetails(kIds);

    if (response.notFoundIDs.isNotEmpty) {
      print('Produkte nicht gefunden: ${response.notFoundIDs}');
      throw ("Not found");
    }

    final ProductDetails product1 = response.productDetails.first;

    const Set<String> kIds2 = {'IronHabitPremiumYear'};
    final ProductDetailsResponse response2 = await InAppPurchase.instance
        .queryProductDetails(kIds2);

    if (response2.notFoundIDs.isNotEmpty) {
      print('Produkte nicht gefunden: ${response2.notFoundIDs}');
      throw ("Not found");
    }

    final ProductDetails product2 = response2.productDetails.first;

    return [product1, product2];
  }
}
