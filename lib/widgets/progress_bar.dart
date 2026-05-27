import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Node $current of $total', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
