import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorsplus/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final Firestore _db = Firestore.instance;
  
  // collection references
  final CollectionReference userCollection = Firestore.instance.collection('users');

  //Update user data that is able to be modified
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    return await userCollection.document(uid).setData({
      'user_fname': userData['fname'] as String,
      'user_lname': userData['lname'] as String,
      'user_dob': userData['date'] as DateTime,
      'user_isTutor': userData['isTutor'] as bool,
      'user_prefs': userData['prefs'] as List<String>,
      'user_favourites': userData['favs'] as List<Map>,
      'user_classes': userData['classes'] as List<Map>,
    });
  }

  //Initialise primary user data when registered
  Future<void> initialiseUserData(Map<String, dynamic> userData) async {
    return await userCollection.document(uid).setData({
      'user_fname': userData['fname'] as String,
      'user_lname': userData['lname'] as String,
      'user_dob': userData['dob'] as DateTime,
      'user_gender': userData['gender'] as String,
      'user_isTutor': false,
      'user_prefs': null,
      'user_favourites': null,
      'user_classes': null,
    });
  }

  // // brew list from snapshot
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc){
  //     //print(doc.data);
  //     return Brew(
  //       name: doc.data['name'] ?? '',
  //       strength: doc.data['strength'] ?? 0,
  //       sugars: doc.data['sugars'] ?? '0'
  //     );
  //   }).toList();
  // }

  // // user data from snapshots
  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //     uid: uid,
  //     name: snapshot.data['name'],
  //     sugars: snapshot.data['sugars'],
  //     strength: snapshot.data['strength']
  //   );
  // }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // // get user doc stream
  // Stream<UserData> get userData {
  //   return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  // }

}