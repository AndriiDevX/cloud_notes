import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_notes/models/note_model.dart';

class FirestoreService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Note>> getNotes(String userId){
    return  _db
    .collection('notes')
    .where('userId', isEqualTo:  userId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc)=> Note.fromFirestore(doc)).toList());
  }

  Future<void> addNote(String title, String content, String userId) async{
    final docRef = _db.collection('notes').doc();
    final note = Note(id: docRef.id, title: title, content: content, userId: userId, createAt: DateTime.now());
    await docRef.set(note.toFirestore());

  }
  Future<void> deleteNote(String noteId)async{
    await _db.collection('notes').doc(noteId).delete();
  }
}
