import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/audio_service.dart';
import '../services/pitch_service.dart';
import '../services/key_detection_service.dart';
import '../widgets/mic_button.dart';
import '../widgets/key_display.dart';
import '../widgets/frequency_meter.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      // Process audio data
      final pitchResult = await _pitchService.detectPitch(audioData);
      
      if (pitchResult != null && mounted) {
        setState(() {
          _currentNote = pitchResult.note;
          _currentFrequency = pitchResult.frequency;
        });
        
        _keyDetectionService.addNote(pitchResult.note, pitchResult.frequency);
      }
    });

    if (success && mounted) {
      setState(() {
        _isListening = true;
      });

      // Update UI periodically
      _processingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) {
          setState(() {});
        }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('KeyFinder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
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
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Key Display Card
            KeyDisplay(
              currentKey: _keyDetectionService.currentKey,
              currentNote: _currentNote,
              frequency: _currentFrequency,
            ),
            
            const SizedBox(height: 32),
            
            // Frequency Meter
            FrequencyMeter(
              frequency: _currentFrequency,
              isActive: _isListening,
            ),
            
            const SizedBox(height: 48),
            
            // Microphone Button
            MicButton(
              isListening: _isListening,
              onPressed: _toggleListening,
            ),
            
            const SizedBox(height: 16),
            
            // Status Text
            Text(
              _isListening ? 'Tap to stop' : 'Tap to start listening',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const Spacer(),
            
            // Notes collected indicator
            if (_isListening && _keyDetectionService.detectedNotes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${_keyDetectionService.detectedNotes.length} notes collected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}