import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/key_detection_service.dart';

class InsightsScreen extends StatefulWidget {
  final KeyDetectionService keyDetectionService;

  const InsightsScreen({
    super.key,
    required this.keyDetectionService,
  });

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late final KeyDetectionService _service = widget.keyDetectionService;

  @override
  void initState() {
    super.initState();
    _service.addListener(_refresh);
  }

  @override
  void dispose() {
    _service.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = _service.history;
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Insights'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 72,
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'Start listening to build insights',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Your stats appear once you save a few detections.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final latest = history.first;
    final totalSessions = history.length;
    final avgConfidence =
        history.map((e) => e.confidence).fold<double>(0, (a, b) => a + b) /
            totalSessions;

    final keyCounts = _aggregateCounts(history.map((r) => r.key));
    final topKeys = keyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final noteCounts = _aggregateCounts(
      history.expand((result) => result.notes),
    );
    final topNotes = noteCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SummaryHeader(
                currentKey: _service.currentKey,
                totalSessions: totalSessions,
                avgConfidence: avgConfidence,
                latest: latest,
              ),
              const SizedBox(height: 24),
              _InsightsCard(
                title: 'Top Keys',
                subtitle: 'Keys you sing or play the most',
                child: Column(
                  children: topKeys.take(3).map((entry) {
                    final percent = (entry.value / totalSessions * 100)
                        .toStringAsFixed(0);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          entry.key.split(' ').first,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      title: Text(entry.key),
                      trailing: Text('$percent%'),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _InsightsCard(
                title: 'Frequent Notes',
                subtitle: 'Notes detected inside saved sessions',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topNotes.take(6).map((entry) {
                    return Chip(
                      label: Text(
                        '${entry.key} (${entry.value})',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      backgroundColor:
                          theme.colorScheme.secondary.withValues(alpha: 0.15),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _aggregateCounts(Iterable<String> values) {
    final counts = <String, int>{};
    for (final value in values) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    return counts;
  }
}

class _SummaryHeader extends StatelessWidget {
  final String currentKey;
  final int totalSessions;
  final double avgConfidence;
  final KeyResult latest;

  const _SummaryHeader({
    required this.currentKey,
    required this.totalSessions,
    required this.avgConfidence,
    required this.latest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.25),
            theme.colorScheme.secondary.withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Currently detecting',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentKey,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryMetric(
                label: 'Sessions',
                value: '$totalSessions',
              ),
              _SummaryMetric(
                label: 'Avg. Confidence',
                value: '${avgConfidence.toStringAsFixed(0)}%',
              ),
              _SummaryMetric(
                label: 'Last Key',
                value: latest.key,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _InsightsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

