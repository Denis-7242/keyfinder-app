class KeyResult {
  final String id;
  final String title;
  final String description;
  final double progress;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String status;

  KeyResult({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    required this.createdAt,
    this.dueDate,
    this.status = 'active',
  });

  factory KeyResult.fromJson(Map<String, dynamic> json) {
    return KeyResult(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      progress: (json['progress'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'status': status,
    };
  }
}