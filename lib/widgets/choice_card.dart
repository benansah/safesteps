import 'package:flutter/material.dart';
import '../models/scenario.dart';

class ChoiceCard extends StatelessWidget {
  final Choice choice;
  final VoidCallback onSelect;

  const ChoiceCard({super.key, required this.choice, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            choice.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
