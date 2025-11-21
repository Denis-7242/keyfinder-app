import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_model.dart';
import '../utilities/note_to_key.dart';

class KeyDetectionService extends ChangeNotifier {
  final List<NoteModel> _detectedNotes = [];
  final int _maxNotes = 50; // Keep last 50 notes for analysis
  final int _minNotesForKey = 8; // Minimum notes before detecting key
  
  String _currentKey = 'Listening...';
  List<KeyResult> _history = [];

  String get currentKey => _currentKey;
  List<KeyResult> get history => _history;
  List<NoteModel> get detectedNotes => _detectedNotes;

  /// Add a detected note to the buffer. Returns true if the displayed key updated.
  bool addNote(String note, double frequency) {
    if (note == 'N/A') return false;
    
    _detectedNotes.add(NoteModel(
      note: note,
      frequency: frequency,
      timestamp: DateTime.now(),
    ));

    // Keep only recent notes
    if (_detectedNotes.length > _maxNotes) {
      _detectedNotes.removeAt(0);
    }

    // Update key detection
    final changed = _updateKeyDetection();
    if (changed) {
      notifyListeners();
    }
    return changed;
  }

  /// Analyze collected notes and determine the key
  bool _updateKeyDetection() {
    if (_detectedNotes.length < _minNotesForKey) {
      final changed = _currentKey != 'Collecting notes...';
      _currentKey = 'Collecting notes...';
      return changed;
    }

    // Get unique notes from recent detections
    List<String> notes = _detectedNotes
        .map((n) => n.note)
        .toList();

    String detectedKey = NoteToKey.detectKey(notes);
    
    if (detectedKey != 'Unknown' && detectedKey != _currentKey) {
      _currentKey = detectedKey;
      
      // Add to history
      _addToHistory(KeyResult(
        key: detectedKey,
        notes: notes.toSet().toList(),
        timestamp: DateTime.now(),
        confidence: _calculateConfidence(notes, detectedKey),
      ));
      return true;
    } else if (detectedKey == 'Unknown') {
      final changed = _currentKey != 'Uncertain';
      _currentKey = 'Uncertain';
      return changed;
    }

    return false;
  }

  /// Calculate confidence score
  double _calculateConfidence(List<String> notes, String key) {
    List<String> keyNotes = NoteToKey.getKeyNotes(key);
    if (keyNotes.isEmpty) return 0.0;

    int matches = 0;
    Set<String> uniqueNotes = notes.toSet();
    
    for (String note in uniqueNotes) {
      if (keyNotes.contains(note)) {
        matches++;
      }
    }

    return (matches / keyNotes.length * 100).clamp(0, 100);
  }

  /// Add key result to history
  void _addToHistory(KeyResult result) {
    _history.insert(0, result);
    if (_history.length > 20) {
      _history.removeLast();
    }
    _saveHistory();
    notifyListeners();
  }

  /// Clear all detected notes and reset
  void reset() {
    _detectedNotes.clear();
    _currentKey = 'Listening...';
    notifyListeners();
  }

  /// Save history to local storage
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> historyJson = _history
          .map((r) => json.encode(r.toJson()))
          .toList();
      await prefs.setStringList('key_history', historyJson);
    } catch (e, stackTrace) {
      debugPrint('Error saving history: $e');
      debugPrint(stackTrace.toString());
    }
  }

  /// Load history from local storage
  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? historyJson = prefs.getStringList('key_history');
      
      if (historyJson != null) {
        _history = historyJson
            .map((str) => KeyResult.fromJson(json.decode(str)))
            .toList();
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading history: $e');
      debugPrint(stackTrace.toString());
    }
    notifyListeners();
  }

  /// Clear history
  Future<void> clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('key_history');
    notifyListeners();
  }
}