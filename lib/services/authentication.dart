import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> singUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth extends BaseAuth{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult _authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email,password: password);
    return _authResult.user;
  }

  @override
  Future<void> signOut() async{
   return _firebaseAuth.signOut();
  }

  @override
  Future<FirebaseUser> singUp(String email, String password) async {
    AuthResult _authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email,password: password);
    return _authResult.user;
  }

  
  @override
  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<bool> isEmailVerified() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> sendEmailVerification() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }

  
}