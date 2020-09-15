import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInAccountAuth(GoogleSignInAccount account) async{

  GoogleSignInAuthentication googleSignInAuthentication = await account.authentication;
  AuthCredential authCredential = GoogleAuthProvider.getCredential(
    idToken: googleSignInAuthentication.idToken,
    accessToken: googleSignInAuthentication.accessToken
  );

  FirebaseUser user = await (firebaseAuth.signInWithCredential(authCredential)) as FirebaseUser;

  return user;
}

Future<FirebaseUser> googleSigninMethod() async{
  GoogleSignInAccount account = await googleSignIn.signIn();
  return await signInAccountAuth(account);
}

//check previous logedin account in the main function




 //  _getPreviousSignedInAccount() async{
  //       GoogleSignInAccount account = _googleSignIn.currentUser;

  //        if(account ==null){
  //              account = await _googleSignIn.signInSilently();
  //        }
  //        return account;
  //  }

  // _checkPreviousLogin() async{
  //   GoogleSignInAccount account = await _getPreviousSignedInAccount();
  //   if(account!=null){
  //      _user = await signInAccountAuth(account);

  //     setState(() {
  //        _isSignedIn = true;
  //        _isloading = false;
  //     });
  //   }
  //   else{
  //     setState(() {
  //       _isloading = false;
  //       _isSignedIn = false;
  //     });
  //   }     
  // }
