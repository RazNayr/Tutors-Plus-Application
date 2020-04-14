import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      
      String errorMessage;

      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Email address is invalid.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Wrong password inputted.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Could not login with those credentials";
      }
      return errorMessage;
    } 
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, Map<String, dynamic> userData) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).initialiseUserData(userData);
      return _userFromFirebaseUser(user);
      
    } catch (error) {
      print(error.toString());
      String errorMessage;

      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email has already been registered.";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Password should be atleast 6 characters long.";
          break;
        default:
          errorMessage = "Could not login with those credentials";
      }
      return errorMessage;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final Firestore _db = Firestore.instance;


  // Future <FirebaseUser> signInWithGoogle() async{
  //   try {
  //     GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //     GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //     AuthResult result = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken
  //     ));

  //     FirebaseUser user = result.user;
  //     return user;
      
  //   } catch (error) {
  //     print(error.toString());
  //     print("Error logging in to Google");
  //     return null;
  //   }
  // }

  // void updateUserData(FirebaseUser user) async {

  // }

  // void signOutGoogle(){

  // }
}