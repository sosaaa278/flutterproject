import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String userId;
  final DateTime createdAt;
  final DateTime? reminder;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.reminder,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reminder: data['reminder'] != null
          ? (data['reminder'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'reminder': reminder != null ? Timestamp.fromDate(reminder!) : null,
    };
  }
}
