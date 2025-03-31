import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String body;
  final String userId;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'user_id': userId
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  factory Note.createNew({
    required String title,
    required String body,
    required String userId,
  }) {
    return Note(
      id: '',
      title: title,
      body: body,
      userId: userId,
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? body,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Note('
        'id: $id, '
        'title: $title, '
        'body: ${body.length > 20 ? '${body.substring(0, 20)}...' : body}, '
        'user_id: $userId, '
        ')';
  }

  static List<dynamic> decodeNotesJson(String jsonString) {
    return jsonDecode(jsonString) as List<dynamic>;
  }
}
