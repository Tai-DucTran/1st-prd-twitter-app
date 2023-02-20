import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userName = FirebaseAuth.instance.currentUser!.displayName;
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  CollectionReference userRef =
      FirebaseFirestore.instance.collection('users_test_model');

  // Create a user first
  Future<void> creatingUserInformation(userName) async {
    await userRef
        .doc(userId)
        .set({'email': userEmail, 'user_id': userId, 'user_name': userName});
  }
}

class PostServiceNew {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userName = FirebaseAuth.instance.currentUser!.displayName;

  CollectionReference userRef =
      FirebaseFirestore.instance.collection('users_test_model');

  // Creating Post
  Future<void> creatingTweet(text) async {
    await userRef.doc(userId).collection('posts').add({
      'creator': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'text': text,
    });
  }
  // Drafting Post

  // Delete Post

}
