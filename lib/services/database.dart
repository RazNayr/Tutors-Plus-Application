import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorsplus/models/tuition.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/models/tutor.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection references
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference tutorCollection = Firestore.instance.collection('tutors');
  final CollectionReference tuitionCollection = Firestore.instance.collection('tuition');

  //Initialise primary user data when registered
  Future<void> initialiseUserData(Map<String, dynamic> userData) async {
    return await userCollection.document(uid).setData({
      'user_fname': userData['fname'] as String,
      'user_lname': userData['lname'] as String,
      'user_dob': userData['dob'] as DateTime,
      'user_gender': userData['gender'] as String,
      'user_isTutor': false,
      'user_interests': new List<String>(),
      'user_search_history': new List<String>(),
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

  Future<void> addUserSearch(String searchCategory) async {

    List<String> _modifiedUserSearchHistoryList = List();
    final DocumentReference userDoc = userCollection.document(uid);
    final searchLimit = 5;

    _modifiedUserSearchHistoryList = await userDoc.get().then((onValue){
      return onValue['user_search_history'].cast<String>();
    });

    if(!_modifiedUserSearchHistoryList.contains(searchCategory)){
      _modifiedUserSearchHistoryList.add(searchCategory);

      if(_modifiedUserSearchHistoryList.length > searchLimit){
        _modifiedUserSearchHistoryList.removeAt(0);
      }

      return await userDoc.updateData({
        'user_search_history': _modifiedUserSearchHistoryList,
      });
    }else{
      return null;
    }
  }

  Future<void> removeUserFavourites(List favouritesToRemove) async {

    List<Map<dynamic, dynamic>> _modifiedFavouritesList = List();
    final DocumentReference doc = userCollection.document(uid);

    // Fetch user favourites from database
    _modifiedFavouritesList = await doc.get().then((onValue){
      return onValue['user_favourites'].cast<Map>();
    });

    // Update modified list of user favourites
    favouritesToRemove.forEach((favToRemove){
      _modifiedFavouritesList.removeWhere((previousFav){
        return previousFav['tuition_ref'].path == favToRemove;
      });
    });

    // Update database with modified list
    return await doc.updateData({
        'user_favourites': _modifiedFavouritesList
    });
  }

  Future<void> addFavourite(Tuition tuition) async {

    List<Map<dynamic, dynamic>> _modifiedFavouritesList = List();
    final DocumentReference userDoc = userCollection.document(uid);
    final DocumentReference tuitionDoc = tuitionCollection.document(tuition.id);
    Map newFavourite = new Map();

    newFavourite['tuition_name'] = tuition.name;
    newFavourite['tuition_category'] = tuition.category;
    newFavourite['tuition_level'] = tuition.level;
    newFavourite['tuition_tutor'] = tuition.tutor;
    newFavourite['tuition_description'] = tuition.description;
    newFavourite['tuition_ref'] = tuitionDoc;
    newFavourite['tuition_tutorRef'] = tuition.tutorRef;
    newFavourite['tuition_isPremium'] = tuition.isPremium;
    newFavourite['tuition_isOnline']= tuition.isOnline;

    // Fetch user favourites from database
    _modifiedFavouritesList = await userDoc.get().then((onValue){
      return onValue['user_favourites'].cast<Map>();
    });

    _modifiedFavouritesList.add(newFavourite);

    // Update database with modified list
    return await userDoc.updateData({
        'user_favourites': _modifiedFavouritesList
    });
  }

  Future<void> removeFavourite(Tuition tuition) async {

    List<Map<dynamic, dynamic>> _modifiedFavouritesList = List();
    final DocumentReference userDoc = userCollection.document(uid);
    final DocumentReference favToRemove = tuitionCollection.document(tuition.id);

    // Fetch user favourites from database
    _modifiedFavouritesList = await userDoc.get().then((onValue){
      return onValue['user_favourites'].cast<Map>();
    });

    // Update modified list of user favourites
    _modifiedFavouritesList.removeWhere((previousFav){
      return previousFav['tuition_ref'].path == favToRemove.path;
    });

    // Update database with modified list
    return await userDoc.updateData({
        'user_favourites': _modifiedFavouritesList
    });
  }

  Future<List<Map>> getUserFavourites() async {
    final DocumentReference userDoc = userCollection.document(uid);
    List<Map> userFavouritesList = List();

    // Fetch user favourites from database
    userFavouritesList = await userDoc.get().then((onValue){
      return onValue['user_favourites'].cast<Map>();
    });

    return userFavouritesList;
  }

  Future<void> enrollInTuition(DocumentReference tutorRef, Map newTuition) async {

    List<Map<dynamic, dynamic>> _modifiedUserLessonsList = List();
    List<DocumentReference> _modifiedStudentsList = List();
    final DocumentReference userDoc = userCollection.document(uid);
    final DocumentReference tutorDoc = tutorCollection.document(tutorRef.documentID);
    bool userAlreadyEnrolled = false;

    // Fetch user lessons from database
    _modifiedUserLessonsList = await userDoc.get().then((onValue){
      return onValue['user_lessons'].cast<Map>();
    });

    // Fetch tutor students from database
    _modifiedStudentsList = await tutorDoc.get().then((onValue){
      return onValue['tutor_students'].cast<DocumentReference>();
    });
    
    _modifiedUserLessonsList.forEach((userLesson){
      if(userLesson['tuition_name'] == newTuition['tuition_name'] && userLesson['tuition_tutorRef'] == newTuition['tuition_tutorRef']){
        userAlreadyEnrolled = true;
      }
    });

    if(!userAlreadyEnrolled){
      _modifiedUserLessonsList.add(newTuition);
      _modifiedStudentsList.add(userDoc);
    }

    // Update tutor docuemnt with modified students list
    await tutorDoc.updateData({
        'tutor_students': _modifiedStudentsList
    });

    // Update database with modified list
    return await userDoc.updateData({
        'user_lessons': _modifiedUserLessonsList
    });
  }

  Future<void> cancelLesson(String tuitionName, DocumentReference tutorRef) async {

    List<Map<dynamic, dynamic>> _modifiedUserLessonList = List();
    final DocumentReference userDoc = userCollection.document(uid);

    _modifiedUserLessonList = await userDoc.get().then((onValue){
      return onValue['user_lessons'].cast<Map>();
    });

    _modifiedUserLessonList.removeWhere((previousLesson){
      return previousLesson['tuition_tutorRef'].path == tutorRef.path && previousLesson['tuition_name'] == tuitionName;
    });

    return await userDoc.updateData({
        'user_lessons': _modifiedUserLessonList
    });
  }

  bool isPastStudent(TutorData tutorData){
    final DocumentReference userDoc = userCollection.document(uid);
    bool isPastStudent = false;
    
    tutorData.students.forEach((studentRef){
      if(studentRef.path == userDoc.path){
        isPastStudent = true;
      }
    });

    return isPastStudent;
  }

  Future<void> addReview(TutorData tutorData, String review, double rating) async {

    final DocumentReference userDoc = userCollection.document(uid);
    final DocumentReference tutorDoc = tutorCollection.document(tutorData.uid);
    String userName;
    List<Map> modifiedReviewsList = new List();
    Map userReview = new Map();
    int totalReviews;
    int totalTutorRatings = 0;
    int newTutorRating;

    userName = await userDoc.get().then((onValue){
      return onValue['user_fname']+" "+onValue['user_lname'];
    });

    modifiedReviewsList = await tutorDoc.get().then((onValue){
      return onValue['tutor_reviews'].cast<Map>();
    });

    userReview['student_name'] = userName;
    userReview['student_rating'] = rating.toInt();
    userReview['student_review'] = review;

    modifiedReviewsList.add(userReview);

    modifiedReviewsList.forEach((review){
      totalTutorRatings += review['student_rating'].toInt();
    });

    totalReviews = modifiedReviewsList.length;
    newTutorRating = totalTutorRatings~/totalReviews;

    // Update database with modified list
    return await tutorDoc.updateData({
        'tutor_rating': newTutorRating,
        'tutor_reviews': modifiedReviewsList,
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
      'tutor_rating': 0,
      'tutor_dob': tutorData['dob'] as DateTime,
      'tutor_isOnline': tutorData['isOnline'] as bool,
      'tutor_isPremium': false,
      'tutor_isWarranted': tutorData['isWarranted'] as bool,
      'tutor_qualifications': tutorData['qualifications'] as List<String>,
      'tutor_reviews': new List<Map>(),
      'tutor_students': new List<DocumentReference>(),
      'tutor_tuition': new List<Map>(),
      'tutor_analytics': new Map()
    });
  }

  Future<void> updateTutorProfileDetails(bool isOnline, bool isWarranted, String bio, List<String> qualifications) async {
    return await tutorCollection.document(uid).updateData({
      'tutor_isOnline': isOnline,
      'tutor_isWarranted': isWarranted,
      'tutor_bio': bio,
      'tutor_qualifications': qualifications,
    });
  }

  Future<void> upgradeToPremium() async{

    List<DocumentReference> tuitionDocRefList = List();
    final DocumentReference tutordoc = tutorCollection.document(uid);

    // Fetch tutor tuition from database
    tuitionDocRefList = await tutordoc.get().then((onValue){
      return onValue['tutor_tuition'].map((item) => item['tuition_ref']).toList().cast<DocumentReference>();
    });

    tuitionDocRefList.forEach((tuitionRef) {
      tuitionCollection.document(tuitionRef.documentID).updateData({
        'tuition_isPremium': true,
      });
    });

    return await tutorCollection.document(uid).updateData({
      'tutor_isPremium': true,
    });
  }

  Future<void> initialiseTuition(Map<String, dynamic> tuitionData) async {

    List<Map<dynamic, dynamic>> _modifiedTutorTuitionList = List();
    Map<dynamic, dynamic> _newTutorTuition = Map();
    final DocumentReference tutordoc = tutorCollection.document(uid);

    // Fetch tutor tuition from database
    _modifiedTutorTuitionList = await tutordoc.get().then((onValue){
      return onValue['tutor_tuition'].cast<Map>();
    });

    //Add needed Tuition details to new tuition map
    _newTutorTuition['tuition_name'] = tuitionData['name'];
    _newTutorTuition['tuition_description'] = tuitionData['description'];
    _newTutorTuition['tuition_level'] = tuitionData['level'];
    _newTutorTuition['tuition_category'] = tuitionData['category'];
    _newTutorTuition['tuition_locality'] = tuitionData['locality'];
    _newTutorTuition['tuition_isOnline'] = tuitionData['isOnline'];
    _newTutorTuition['tuition_isPremium'] = tuitionData['isPremium'];
    _newTutorTuition['tuition_geopoint'] = tuitionData['geopoint'];

    // Add a new document with a generated id.
    return await tuitionCollection.add({
      'tuition_name': tuitionData['name'],
      'tuition_description': tuitionData['description'],
      'tuition_level': tuitionData['level'],
      'tuition_category': tuitionData['category'],
      'tuition_locality': tuitionData['locality'],
      'tuition_isOnline': tuitionData['isOnline'],
      'tuition_isPremium': tuitionData['isPremium'],
      'tuition_tutor': tuitionData['tutor'],
      'tuition_tutorRef': tutordoc,
      'tuition_geopoint': tuitionData['geopoint'],
    })
    .then((tuitionDocRef) async {
      _newTutorTuition['tuition_ref'] = tuitionDocRef;

      // Add new tuition to list of tutor tuition
      _modifiedTutorTuitionList.add(_newTutorTuition);

      // Update tutor doc with modified list
      await tutordoc.updateData({
          'tutor_tuition': _modifiedTutorTuitionList
      });
    });
  }

  Future<void> removeTuition(DocumentReference tuitionDoc, int tuitionIndex, String tuitionName) async {

    List<Map<dynamic, dynamic>> _modifiedTutorTuitionList = List();
    final DocumentReference tutordoc = tutorCollection.document(uid);

    // Fetch tutor tuition from database
    _modifiedTutorTuitionList = await tutordoc.get().then((onValue){
      return onValue['tutor_tuition'].cast<Map>();
    });

    // Remove tuition at specified index in Tutor's list of Tuitions
    _modifiedTutorTuitionList.removeAt(tuitionIndex);

    // Update tutor doc with modified list
    await tutordoc.updateData({
        'tutor_tuition': _modifiedTutorTuitionList
    });

    userCollection.getDocuments().then((onValue){
      onValue.documents.forEach((userDoc) async{
        List userLessons = userDoc['user_lessons'].cast<Map>();
        List userFavourites = userDoc['user_favourites'].cast<Map>();

        List copyUserList = List.from(userLessons);
        copyUserList.forEach((lesson){
          if(lesson['tuition_name'] == tuitionName && lesson['tuition_tutorRef'].path == tutordoc.path){
            userLessons.remove(lesson);
          }
        });

        copyUserList = List.from(userFavourites);
        copyUserList.forEach((favourite){
          if(favourite['tuition_name'] == tuitionName && favourite['tuition_tutorRef'].path == tutordoc.path){
            userFavourites.remove(favourite);
          }
        });

        await userCollection.document(userDoc.documentID).updateData({
          'user_lessons': userLessons,
          'user_favourites': userFavourites
        });

      });
    });

    return await tuitionCollection.document(tuitionDoc.documentID).delete();
  }

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

  // get tutor doc stream
  Stream<TutorData> get tutorData {
    return tutorCollection.document(uid).snapshots()
      .map(_tutorDataFromSnapshot);
  }

  // get selected tutor doc stream
  Stream<TutorData> selectedTutorData(DocumentReference tutorRef) {
    return tutorCollection.document(tutorRef.documentID).snapshots()
      .map(_tutorDataFromSnapshot);
  }

  // tutor data from snapshots
  TutorData _tutorDataFromSnapshot(DocumentSnapshot snapshot) {
    return TutorData(
      uid: snapshot.documentID,
      fname: snapshot.data['tutor_fname'],
      lname: snapshot.data['tutor_lname'],
      bio: snapshot.data['tutor_bio'],
      dob: snapshot.data['tutor_dob'],
      isOnline: snapshot.data['tutor_isOnline'],
      isPremium: snapshot.data['tutor_isPremium'],
      isWarranted: snapshot.data['tutor_isWarranted'],
      rating: snapshot.data['tutor_rating'],

      reviews: snapshot.data['tutor_reviews'].cast<Map<dynamic, dynamic>>(),
      tuition: snapshot.data['tutor_tuition'].cast<Map<dynamic, dynamic>>(),
      qualifications: snapshot.data['tutor_qualifications'].cast<String>(),
      students: snapshot.data['tutor_students'].cast<DocumentReference>(),

      analytics: snapshot.data['tutor_analytics'],
    );
  }

  // get brews stream
  Stream<List<Tuition>> get tuitionList {
    return tuitionCollection.snapshots()
      .map(_tuitionListFromSnapshot);
  }

  
    // brew list from snapshot
  List<Tuition> _tuitionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Tuition(
        id: doc.documentID,
        isPremium: doc.data['tuition_isPremium'],
        isOnline: doc.data['tuition_isOnline'],
        category: doc.data['tuition_category'],
        level: doc.data['tuition_level'],
        name: doc.data['tuition_name'],
        tutor: doc.data['tuition_tutor'],
        description: doc.data['tuition_description'],
        locality: doc.data['tuition_locality'],
        tutorRef: doc.data['tuition_tutorRef'],
        latitude: doc.data['tuition_geopoint'].latitude,
        longitude: doc.data['tuition_geopoint'].longitude,
      );
    }).toList();
  }

}