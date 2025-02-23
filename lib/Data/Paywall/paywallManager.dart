import 'package:flutter/material.dart';
import 'package:keep_learning/Data/Paywall/PurchaseController.dart';
import 'package:keep_learning/Data/Paywall/paywall.dart';
import 'package:keep_learning/Data/Porviders/paywallProvider.dart';
import 'package:keep_learning/Views/home.dart';
import 'package:provider/provider.dart';

class PaywallManager extends StatelessWidget {
  const PaywallManager({super.key});

  @override
  Widget build(BuildContext context) {
    final paywallProvider = Provider.of<PaywallProvider>(context);
    return paywallProvider.pro ? Home() : Paywall();
  }
}
