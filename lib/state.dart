import 'package:firebase_auth/firebase_auth.dart';


class StateModel{
  bool isloading;
  FirebaseUser user;
  
StateModel(
  {
    this.isloading = false,
    this.user,
  }
);
}