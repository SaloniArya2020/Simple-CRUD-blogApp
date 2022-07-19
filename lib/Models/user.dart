import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uid;
  String username;
  String email;
  String profilePhoto;

  Users({required this.uid, required this.email, required this.username, required this.profilePhoto });

  factory Users.FromDocument(DocumentSnapshot doc) {
    return Users(
        uid: doc['uid'], email: doc['email'], username: doc['username'], profilePhoto: doc['profilePhoto']);
  }
}
