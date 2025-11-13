class NoteToKey {
  // Major scale intervals from root
  static const List<int> majorIntervals = [0, 2, 4, 5, 7, 9, 11];
  
  // Minor scale intervals from root
  static const List<int> minorIntervals = [0, 2, 3, 5, 7, 8, 10];
  
  static const List<String> allNotes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  /// Determines the most likely key from a list of detected notes
  static String detectKey(List<String> detectedNotes) {
    if (detectedNotes.isEmpty) {
      return 'Unknown';
    }

    // Count note occurrences
    Map<String, int> noteCount = {};
    for (String note in detectedNotes) {
      noteCount[note] = (noteCount[note] ?? 0) + 1;
    }

    // Convert notes to indices
    Set<int> noteIndices = noteCount.keys
        .map((note) => allNotes.indexOf(note))
        .where((idx) => idx != -1)
        .toSet();

    if (noteIndices.isEmpty) {
      return 'Unknown';
    }

    // Test all possible keys
    Map<String, int> keyScores = {};
    
    for (int rootIdx = 0; rootIdx < 12; rootIdx++) {
      String rootNote = allNotes[rootIdx];
      
      // Test major key
      int majorScore = _scoreKey(noteIndices, rootIdx, majorIntervals);
      keyScores['$rootNote Major'] = majorScore;
      
      // Test minor key
      int minorScore = _scoreKey(noteIndices, rootIdx, minorIntervals);
      keyScores['$rootNote Minor'] = minorScore;
    }

    // Find the key with the highest score
    String bestKey = 'Unknown';
    int bestScore = 0;
    
    keyScores.forEach((key, score) {
      if (score > bestScore) {
        bestScore = score;
        bestKey = key;
      }
    });

    return bestScore > 0 ? bestKey : 'Unknown';
  }

  /// Score how well the detected notes fit a particular key
  static int _scoreKey(Set<int> noteIndices, int rootIdx, List<int> intervals) {
    int score = 0;
    
    // Generate the scale for this key
    Set<int> scaleNotes = intervals.map((interval) => (rootIdx + interval) % 12).toSet();
    
    // Count matches
    for (int noteIdx in noteIndices) {
      if (scaleNotes.contains(noteIdx)) {
        score += 2; // Notes in scale get +2
      } else {
        score -= 1; // Notes not in scale get -1
      }
    }
    
    return score;
  }

  /// Get the notes in a specific key
  static List<String> getKeyNotes(String key) {
    if (!key.contains('Major') && !key.contains('Minor')) {
      return [];
    }

    String rootNote = key.split(' ')[0];
    bool isMajor = key.contains('Major');
    
    int rootIdx = allNotes.indexOf(rootNote);
    if (rootIdx == -1) return [];

    List<int> intervals = isMajor ? majorIntervals : minorIntervals;
    
    return intervals
        .map((interval) => allNotes[(rootIdx + interval) % 12])
        .toList();
  }
}