import 'package:flutter/material.dart';

import '../services/key_detection_service.dart';

class SettingsScreen extends StatefulWidget {
  final KeyDetectionService keyDetectionService;

  const SettingsScreen({
    super.key,
    required this.keyDetectionService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSaveHistory = true;
  bool _showNoteNames = true;
  bool _vibrateOnKey = false;

  late final KeyDetectionService _service = widget.keyDetectionService;

  @override
  void initState() {
    super.initState();
    _service.addListener(_handleServiceUpdate);
  }

  void _handleServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _service.removeListener(_handleServiceUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SectionHeader(
            title: 'Recording',
            subtitle: 'Customize how KeyFinder listens and stores results.',
          ),
          _buildSwitchTile(
            title: 'Auto-save history',
            subtitle: 'Store reliable detections for later review.',
            value: _autoSaveHistory,
            onChanged: (value) => setState(() => _autoSaveHistory = value),
          ),
          _buildSwitchTile(
            title: 'Show note names',
            subtitle: 'Display note letters on the live tuner view.',
            value: _showNoteNames,
            onChanged: (value) => setState(() => _showNoteNames = value),
          ),
          _buildSwitchTile(
            title: 'Vibrate when a key is found',
            subtitle: 'Use haptics to confirm new key detections.',
            value: _vibrateOnKey,
            onChanged: (value) => setState(() => _vibrateOnKey = value),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: 'Data',
            subtitle: 'Manage your stored detections and privacy.',
          ),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Saved sessions'),
                  subtitle: Text(
                    '${_service.history.length} entries stored on this device',
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  title: const Text('Clear detection history'),
                  subtitle: const Text('Removes all saved keys immediately.'),
                  onTap: _clearHistory,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: 'About',
            subtitle: 'Version info and project links.',
          ),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  subtitle: Text('KeyFinder v1.0.0'),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy'),
                  subtitle: Text('Audio is processed on-device only.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history'),
        content: const Text('This will delete all saved keys. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.clearHistory();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History cleared')),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

