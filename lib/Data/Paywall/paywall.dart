import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:keep_learning/Data/Paywall/PurchaseController.dart';
import 'package:keep_learning/Data/Porviders/paywallProvider.dart';
import 'package:keep_learning/Views/errorPage.dart';
import 'package:provider/provider.dart';

class Paywall extends StatefulWidget {
  const Paywall({super.key});

  @override
  State<Paywall> createState() => _PaywallState();
}

List<bool> selectedItem = [true, false];

class _PaywallState extends State<Paywall> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final paywallProvider = Provider.of<PaywallProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Commit to IronHabit")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: Column(
          children: [
            Expanded(child: Benefits()),
            FutureBuilder(
              future: paywallProvider.getSubscriptionDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SubscripeButton(
                        selected: selectedItem[0],
                        productDetails: snapshot.data![0],
                        onTap: () {
                          setState(() {
                            selectedItem[0] = true;
                            selectedItem[1] = false;
                          });
                        },
                      ),
                      SubscripeButton(
                        selected: selectedItem[1],
                        productDetails: snapshot.data![1],
                        annual: true,
                        save:
                            ((snapshot.data![1].rawPrice /
                                    (snapshot.data![0].rawPrice * 12)) *
                                100),
                        onTap: () {
                          setState(() {
                            selectedItem[1] = true;
                            selectedItem[0] = false;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (paywallProvider.processing) {
                            return;
                          }

                          String id =
                              snapshot.data![selectedItem.indexOf(true)].id;
                          print("Tap");

                          paywallProvider.purchase(id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                paywallProvider.processing
                                    ? Colors.transparent
                                    : selectedColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child:
                                paywallProvider.processing
                                    ? CircularProgressIndicator()
                                    : Text(
                                      "Start a 7-Day Free Trial",
                                      style: TextStyle(
                                        color:
                                            isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedItem[0])
                        Text(
                          "7 days free, then ${snapshot.data![0].price} per month. Cancel Anytime",
                          style: TextStyle(fontSize: 13),
                        ),
                      if (selectedItem[1])
                        Text(
                          "7 days free, then ${snapshot.data![1].price} per year. Cancel Anytime",
                          style: TextStyle(fontSize: 13),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text("Restore purchases"),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Terms of uses"),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Somehting went wrong. Please try later again.",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: 100, child: CircularProgressIndicator()),
                    SizedBox(height: 100),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Benefits extends StatelessWidget {
  const Benefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Benefit(
          iconData: Icons.timer_off,
          text: "No Excuses – The timer stops automatically",
        ),
        Benefit(
          iconData: Icons.gavel,
          text: "Harsh but Effective – Fail and face a time penalty",
        ),
        Benefit(
          iconData: Icons.block,
          text: "Stay Focused – Fullscreen timer blocks distractions",
        ),
        Benefit(
          iconData: Icons.emoji_events,
          text: "Achieve More – Stay consistent and reach your goals",
        ),
      ],
    );
  }
}

class Benefit extends StatelessWidget {
  final String text;
  final IconData iconData;

  const Benefit({super.key, required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(iconData, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscripeButton extends StatefulWidget {
  final bool selected;
  final bool annual;
  final double save;
  final VoidCallback onTap;
  final ProductDetails productDetails;

  const SubscripeButton({
    super.key,
    required this.selected,
    required this.productDetails,
    this.annual = false,
    this.save = 0,
    required this.onTap,
  });

  @override
  State<SubscripeButton> createState() => _SubscripeButtonState();
}

class _SubscripeButtonState extends State<SubscripeButton> {
  @override
  Widget build(BuildContext context) {
    final Color unselectedColor =
        Theme.of(context).colorScheme.surfaceContainerHigh;
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color:
                widget.selected
                    ? selectedColor.withAlpha(30)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.selected ? selectedColor : unselectedColor,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.productDetails.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      widget.productDetails.price,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
