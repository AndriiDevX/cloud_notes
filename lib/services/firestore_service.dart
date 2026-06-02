import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_notes/models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Note>> getNotes(String userId) {
    return _db
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }

 Future<void> addNote(String title, String content, String userId) async {
    final docRef = _db.collection('notes').doc();
    try {
      final note = Note(
        id: docRef.id,
        title: title,
        content: content,
        userId: userId,
        createAt: DateTime.now(),
      );

      await docRef.set(note.toFirestore());
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    await _db.collection('notes').doc(noteId).delete();
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    try {
      await _db.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }
}
