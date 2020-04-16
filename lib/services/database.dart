import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorsplus/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection references
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference tutorCollection = Firestore.instance.collection('tutors');

  //Update user data that is able to be modified
  // Future<void> updateUserData(Map<String, dynamic> userData) async {
  //   return await userCollection.document(uid).updateData({
  //     'user_fname': userData['fname'] as String,
  //     'user_lname': userData['lname'] as String,
  //     'user_dob': userData['date'] as DateTime,
  //     'user_isTutor': userData['isTutor'] as bool,
  //     'user_interests': userData['interests'] as List<String>,
  //     'user_favourites': userData['favs'] as List<Map>,
  //     'user_classes': userData['classes'] as List<Map>,
  //   });
  // }

  //Initialise primary user data when registered
  Future<void> initialiseUserData(Map<String, dynamic> userData) async {
    return await userCollection.document(uid).setData({
      'user_fname': userData['fname'] as String,
      'user_lname': userData['lname'] as String,
      'user_dob': userData['dob'] as DateTime,
      'user_gender': userData['gender'] as String,
      'user_isTutor': false,
      'user_interests': new List<String>(),
      'user_favourites': new List<Map>(),
      'user_lessons': new List<Map>(),
    });
  }

  Future<void> updateUserProfileDetails(String fname, String lname, List<String> interests) async {
    return await userCollection.document(uid).updateData({
      'user_fname': fname,
      'user_lname': lname,
      'user_interests': interests,
    });
  }

  Future<void> removeUserFavourites(List favouritesToRemove) async {

    List<Map<dynamic, dynamic>> _modifiedFavouritesList = List();
    final DocumentReference doc = userCollection.document(uid);

    // Fetch user favourites from database
    _modifiedFavouritesList = await doc.get().then((onValue){
      return onValue['user_favourites'].cast<Map>();
    });

    // Update modified list of user favourites
    favouritesToRemove.forEach((removedFav){
      _modifiedFavouritesList.removeWhere((previousFav){
        return previousFav['tuition_ref'].path == removedFav;
      });
    });

    // Update database with modified list
    return await doc.updateData({
        'user_favourites': _modifiedFavouritesList
    });
  }

  Future<void> initialiseTutor(Map<String, dynamic> tutorData) async {

    await userCollection.document(uid).updateData({
      'user_isTutor': true,
    });

    return await tutorCollection.document(uid).setData({
      'tutor_fname': tutorData['fname'] as String,
      'tutor_lname':  tutorData['lname'] as String,
      'tutor_bio': null,
      'tutor_dob': tutorData['dob'] as DateTime,
      'tutor_isOnline': tutorData['isOnline'] as bool,
      'tutor_isPremium': false,
      'tutor_isWarranted': tutorData['isWarranted'] as bool,
      'tutor_qualifications': tutorData['qualifications'] as List<String>,
      'tutor_remarks': new List<Map>(),
      'tutor_students': new List<DocumentReference>(),
      'tutor_tuition': new List<Map>(),
      'tutor_analytics': new Map()
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

  //This function is really beneficial is you need a static object which will never change. Otherwise, always sue streams.
  // List<String> userPrefsFromSnapshot() {
  //   //DOC REFERENCE TO SET AND UPDATE DATA
  //   final DocumentReference doc = userCollection.document(uid);
  //   doc.get().then((onValue){
  //     return onValue['user_interests'];
  //   });
  // }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      fname: snapshot.data['user_fname'],
      lname: snapshot.data['user_lname'],
      dob: snapshot.data['user_dob'],
      isTutor: snapshot.data['user_isTutor'],
      interests: snapshot.data['user_interests'].cast<String>(),
      favourites: snapshot.data['user_favourites'].cast<Map<dynamic, dynamic>>(),
      lessons: snapshot.data['user_lessons'].cast<Map<dynamic, dynamic>>(),
    );
  }
  

}