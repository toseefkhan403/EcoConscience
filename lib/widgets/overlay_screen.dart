import 'package:flutter/material.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}