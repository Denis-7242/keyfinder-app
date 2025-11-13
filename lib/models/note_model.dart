class NoteModel {
  final String note;
  final double frequency;
  final DateTime timestamp;

  NoteModel({
    required this.note,
    required this.frequency,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'note': note,
    'frequency': frequency,
    'timestamp': timestamp.toIso8601String(),
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    note: json['note'],
    frequency: json['frequency'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class KeyResult {
  final String key;
  final List<String> notes;
  final DateTime timestamp;
  final double confidence;

  KeyResult({
    required this.key,
    required this.notes,
    required this.timestamp,
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'notes': notes,
    'timestamp': timestamp.toIso8601String(),
    'confidence': confidence,
  };

  factory KeyResult.fromJson(Map<String, dynamic> json) => KeyResult(
    key: json['key'],
    notes: List<String>.from(json['notes']),
    timestamp: DateTime.parse(json['timestamp']),
    confidence: json['confidence'] ?? 0.0,
  );
}