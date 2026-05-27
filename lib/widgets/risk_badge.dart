import 'package:flutter/material.dart';

class RiskBadge extends StatelessWidget {
  final String level;

  const RiskBadge({super.key, required this.level});

  Color get badgeColor {
    switch (level.toLowerCase()) {
      case 'high':
        return const Color(0xFF922B21);
      case 'medium':
        return const Color(0xFFB7770D);
      default:
        return const Color(0xFF1E8449);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
      ),
    );
  }
}
