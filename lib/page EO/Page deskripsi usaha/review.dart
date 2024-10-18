import 'package:flutter/material.dart';

class ReviewUsaha extends StatefulWidget {
  const ReviewUsaha({super.key});

  @override
  State<ReviewUsaha> createState() => _ReviewUsahaState();
}

class _ReviewUsahaState extends State<ReviewUsaha> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "4.8",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  '5',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                LinearProgressIndicator()
              ],
            )
          ],
        )
      ],
    );
  }
}
