import 'package:flutter/material.dart';

class KeyDisplay extends StatelessWidget {
  final String currentKey;
  final String currentNote;
  final double frequency;

  const KeyDisplay({
    super.key,
    required this.currentKey,
    required this.currentNote,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current Note
            Text(
              'Current Note',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentNote,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${frequency.toStringAsFixed(1)} Hz',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 32),
            
            // Divider
            Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
            
            const SizedBox(height: 32),
            
            // Detected Key
            Text(
              'Detected Key',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentKey,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}