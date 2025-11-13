import 'dart:math';

class FrequencyToNote {
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];
  
  static const double a4Frequency = 440.0;
  static const int a4MidiNote = 69;

  /// Converts frequency in Hz to the nearest musical note
  static String frequencyToNote(double frequency) {
    if (frequency < 20 || frequency > 4200) {
      return 'N/A';
    }

    // Calculate the MIDI note number
    int midiNote = (12 * log(frequency / a4Frequency) / log(2) + a4MidiNote).round();
    
    // Get the note name (without octave)
    String noteName = noteNames[midiNote % 12];
    
    return noteName;
  }

  /// Get note with octave
  static String frequencyToNoteWithOctave(double frequency) {
    if (frequency < 20 || frequency > 4200) {
      return 'N/A';
    }

    int midiNote = (12 * log(frequency / a4Frequency) / log(2) + a4MidiNote).round();
    String noteName = noteNames[midiNote % 12];
    int octave = (midiNote ~/ 12) - 1;
    
    return '$noteName$octave';
  }

  /// Calculate cents deviation from perfect pitch
  static double getCentsDeviation(double frequency) {
    if (frequency < 20 || frequency > 4200) {
      return 0.0;
    }

    int midiNote = (12 * log(frequency / a4Frequency) / log(2) + a4MidiNote).round();
    double perfectFrequency = a4Frequency * pow(2, (midiNote - a4MidiNote) / 12);
    double cents = 1200 * log(frequency / perfectFrequency) / log(2);
    
    return cents;
  }
}