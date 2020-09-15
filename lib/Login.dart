import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_schedular/Home.dart';
import 'package:task_schedular/state_widget.dart';
import 'package:task_schedular/updateinfo.dart';
import 'state.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement creaLoginate
    return LoginState();
  }
}

class LoginState extends State<Login>{
  StateModel appState;
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  bool _isEmailVerified = false;

void resetForm(){
  setState(() {
    _formKey.currentState.reset();
    _errorMessage = "";
  });
}

 void toogleFormMode(){
   resetForm();
   setState(() {
     _isLoginForm = !_isLoginForm;
   });
 }

  bool validateAndSave(){
    final _form = _formKey.currentState;
    if(_form.validate()){
      _form.save();
      return true;
    }
    else
    return false;
  }

  void validateAndSubmit() async{
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if(validateAndSave()){
      FirebaseUser _user;
      try{
        if(_isLoginForm){
          AuthResult s= await FirebaseAuth.instance.
          signInWithEmailAndPassword(email: _email,password: _password);
          _user = s.user;
          setState(() {
            appState.user = _user;
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
        }else{
          setState(() {
            appState.isloading = true;
          });
          await FirebaseAuth.instance.
          createUserWithEmailAndPassword(email: _email,password:_password).then((value){
                _user = value.user;
          setState(() {
            appState.user = _user;
            appState.isloading = false;
          });
          });
          setState(() {
            _isLoading = true;
          });
         await  _user.sendEmailVerification().then((value){
           setState(() {
             _isEmailVerified = _user.isEmailVerified;
             print(_isEmailVerified);
           });
         });
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateInfo(true)));
          // if(_isEmailVerified){
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateInfo()));
          // }
          // else{
          //   exit(0);
          // }
        }
      }catch(e){
        print('Errot $e');
        setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _formKey.currentState.reset();
        });
      }
    }

  }

Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
   Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toogleFormMode
    );
  }

Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed:validateAndSubmit,
          ),
        ));
  }


_showCircularProcess(){
  if(_isLoading== true){
    return Center(child: CircularProgressIndicator(),);
  }
  return Container(height: 0.0,width: 0.0,);
}


_showForm(){
  return new Container(
    padding: EdgeInsets.all(16),
    child: Form(
      key: _formKey,
      child: new ListView(
      shrinkWrap: true,
      children: <Widget>[
        _showLogo(),
        _showEmailInput(),
        _showPasswordInput(),
        _showPrimaryButton(),
        _showSecondaryButton(),
        _showErrorMessage()
      ],
      ),
    ),
  );
}

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
  
  var scaffold = Scaffold(
    backgroundColor: Colors.white,
    body: Stack(children: <Widget>[
      _showForm(),
      _showCircularProcess(),
    ],)
  );
    return scaffold;
  }
}



