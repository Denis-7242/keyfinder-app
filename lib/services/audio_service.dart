import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _amplitudeSubscription;
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start recording audio stream
  Future<bool> startRecording(Function(Uint8List) onData) async {
    try {
      if (_isRecording) return true;

      final hasPermission = await requestPermission();
      if (!hasPermission) return false;

      // Check if recording is supported
      if (!await _recorder.hasPermission()) {
        return false;
      }

      // Start recording with stream
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 44100,
          numChannels: 1,
        ),
      );

      _amplitudeSubscription = stream.listen(onData);
      _isRecording = true;
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error starting recording: $e');
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    try {
      if (!_isRecording) return;

      await _amplitudeSubscription?.cancel();
      await _recorder.stop();
      _isRecording = false;
    } catch (e, stackTrace) {
      debugPrint('Error stopping recording: $e');
      debugPrint(stackTrace.toString());
    }
  }

  /// Dispose resources
  void dispose() {
    _amplitudeSubscription?.cancel();
    _recorder.dispose();
  }
}

// Uint8List for audio data
