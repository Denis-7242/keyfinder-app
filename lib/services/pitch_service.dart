import 'dart:typed_data';
import 'package:pitch_detector_dart/pitch_detector.dart';
import '../utilities/frequency_to_note.dart';

class PitchService {
  final PitchDetector _pitchDetector = PitchDetector(44100, 2048);
  
  /// Analyze audio buffer and return detected pitch
  Future<PitchResult?> detectPitch(Uint8List audioData) async {
    try {
      // Convert Uint8List to List<double>
      List<double> audioBuffer = _convertToDoubleList(audioData);
      
      if (audioBuffer.length < 2048) {
        return null;
      }

      // Detect pitch
      final result = _pitchDetector.getPitch(audioBuffer);
      
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

  /// Convert audio bytes to double list for pitch detection
  List<double> _convertToDoubleList(Uint8List audioData) {
    List<double> result = [];
    
    // Convert PCM16 bytes to double samples (-1.0 to 1.0)
    for (int i = 0; i < audioData.length - 1; i += 2) {
      int sample = audioData[i] | (audioData[i + 1] << 8);
      // Convert to signed
      if (sample > 32767) {
        sample = sample - 65536;
      }
      // Normalize to -1.0 to 1.0
      result.add(sample / 32768.0);
    }
    
    return result;
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