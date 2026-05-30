import 'package:flutter/material.dart';

class ConnectionBadge extends StatelessWidget {
  const ConnectionBadge({super.key, required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isConnected ? Colors.green : colorScheme.error;
    final text = isConnected ? 'Online' : 'Offline';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 10, width: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
