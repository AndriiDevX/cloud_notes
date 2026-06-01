import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String userId;
  final DateTime createAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createAt,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userid'] ?? '',
      createAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toFirestore(){
    return{
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createAt)
    };
  }
}
