import 'dart:typed_data';
import 'package:pitch_detector_dart/pitch_detector.dart';
import '../utilities/frequency_to_note.dart';

class PitchService {
  final PitchDetector _pitchDetector = PitchDetector(
    audioSampleRate: 44100,
    bufferSize: 2048,
  );

  /// Analyze audio buffer and return detected pitch
  Future<PitchResult?> detectPitch(Uint8List audioData) async {
    try {
      // Convert Uint8List to List<double> if you choose float route,
      // but since we have Int buffer feed, we can use Int method directly.
      
      // Use PCM16 Int buffer method
      final result = await _pitchDetector.getPitchFromIntBuffer(audioData);

      if (result.pitched && result.pitch > 0) {
        String note = FrequencyToNote.frequencyToNote(result.pitch);
        double cents = FrequencyToNote.getCentsDeviation(result.pitch);

        return PitchResult(
          frequency: result.pitch,
          note: note,
          cents: cents,
          confidence: result.probability,
        );
      }

      return null;
    } catch (e) {
      print('Error detecting pitch: $e');
      return null;
    }
  }
}

class PitchResult {
  final double frequency;
  final String note;
  final double cents;
  final double confidence;

  PitchResult({
    required this.frequency,
    required this.note,
    required this.cents,
    required this.confidence,
  });
}
