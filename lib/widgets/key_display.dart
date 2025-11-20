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
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.7),
            theme.colorScheme.surface.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current Note',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              currentNote,
              key: ValueKey(currentNote),
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              '${frequency.toStringAsFixed(1)} Hz',
              key: ValueKey(frequency.toStringAsFixed(1)),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Opacity(
            opacity: 0.4,
            child: Divider(
              thickness: 1,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Detected Key',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              currentKey,
              key: ValueKey(currentKey),
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}