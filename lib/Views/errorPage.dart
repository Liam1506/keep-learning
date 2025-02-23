import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({super.key, this.error = "Unknown Error"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Seems like something went wrong...",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 5),
            Text(error, textAlign: TextAlign.right),
            const SizedBox(height: 20),
            FilledButton(onPressed: () {}, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
