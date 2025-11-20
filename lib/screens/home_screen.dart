import 'dart:async';

import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/key_detection_service.dart';
import '../services/pitch_service.dart';
import '../widgets/frequency_meter.dart';
import '../widgets/key_display.dart';
import '../widgets/mic_button.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();
  final PitchService _pitchService = PitchService();
  final KeyDetectionService _keyDetectionService = KeyDetectionService();
  
  bool _isListening = false;
  String _currentNote = '--';
  double _currentFrequency = 0.0;
  Timer? _processingTimer;

  @override
  void initState() {
    super.initState();
    _keyDetectionService.loadHistory();
  }

  @override
  void dispose() {
    _stopListening();
    _audioService.dispose();
    _processingTimer?.cancel();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    final success = await _audioService.startRecording((audioData) async {
      final pitchResult = await _pitchService.detectPitch(audioData);

      if (pitchResult != null && mounted) {
        final keyChanged = _keyDetectionService.addNote(
          pitchResult.note,
          pitchResult.frequency,
        );

        setState(() {
          _currentNote = pitchResult.note;
          _currentFrequency = pitchResult.frequency;
          if (keyChanged) {
            // Trigger rebuild so the UI reflects the new key immediately.
          }
        });
      }
    });

    if (success && mounted) {
      setState(() {
        _isListening = true;
      });

      _processingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) setState(() {});
      });
    } else {
      _showPermissionDialog();
    }
  }

  void _stopListening() {
    _audioService.stopRecording();
    _processingTimer?.cancel();
    if (mounted) {
      setState(() {
        _isListening = false;
        _currentNote = '--';
        _currentFrequency = 0.0;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'Please grant microphone permission in your device settings to use this app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('KeyFinder'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070A1D), Color(0xFF11173B), Color(0xFF1B2351)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.4),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(
                            keyDetectionService: _keyDetectionService,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        KeyDisplay(
                          currentKey: _keyDetectionService.currentKey,
                          currentNote: _currentNote,
                          frequency: _currentFrequency,
                        ),
                        const SizedBox(height: 20),
                        _StatusChips(
                          isListening: _isListening,
                          noteCount: _keyDetectionService.detectedNotes.length,
                        ),
                        const SizedBox(height: 20),
                        _MeterCard(
                          isListening: _isListening,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Live Frequency',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FrequencyMeter(
                                frequency: _currentFrequency,
                                isActive: _isListening,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${_currentFrequency.toStringAsFixed(1)} Hz',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _MeterCard(
                          isListening: _isListening,
                          child: Column(
                            children: [
                              Text(
                                _isListening ? 'Tap to stop listening' : 'Tap to start listening',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              MicButton(
                                isListening: _isListening,
                                onPressed: _toggleListening,
                              ),
                              if (_isListening && _keyDetectionService.detectedNotes.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    '${_keyDetectionService.detectedNotes.length} notes captured',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  final bool isListening;
  final int noteCount;

  const _StatusChips({
    required this.isListening,
    required this.noteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatusTile(
            label: isListening ? 'Status' : 'Ready',
            value: isListening ? 'Listening' : 'Idle',
            icon: isListening ? Icons.graphic_eq : Icons.pause_circle,
            accent: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusTile(
            label: 'Samples',
            value: '$noteCount notes',
            icon: Icons.music_note,
            accent: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatusTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface.withValues(alpha: 0.35),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.25),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeterCard extends StatelessWidget {
  final bool isListening;
  final Widget child;

  const _MeterCard({
    required this.isListening,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.colorScheme.surface.withValues(alpha: 0.35),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: isListening ? 0.4 : 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 25,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}
