import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  // 🔥 Obtener solo las notas del usuario actual
  Stream<List<Note>> getNotes() {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

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
      }).toList();
    });
  }

  // 🔥 Agregar nota con userId
  Future<void> addNote(String title, String content, DateTime? reminder) async {
    await _firestore.collection('notes').add({
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
    });
  }

  // 🔥 Eliminar nota
  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
