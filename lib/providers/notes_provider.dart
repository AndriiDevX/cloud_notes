import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_notes/models/note_model.dart';
import 'auth_provider.dart';
import 'package:cloud_notes/services/firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final notesStreamProvider =  StreamProvider<List<Note>>((ref) {
  final authState = ref.watch(authProvider);

  if  (authState == null){
    return Stream.value([]);
  }
  return ref.watch(firestoreServiceProvider).getNotes(authState.uid);
});