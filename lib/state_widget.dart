import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:task_schedular/services/authentication.dart';
import 'package:task_schedular/state.dart';


class StateWidget extends StatefulWidget{
  StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state
    });

  static _StateWidgetState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(MyInheritedWidget)as MyInheritedWidget).data;
  }

  @override
  State<StatefulWidget> createState() {
    return _StateWidgetState();
  }

}

class _StateWidgetState extends State<StateWidget>{
  StateModel state;
  Auth auth;
  @override
  void initState() {
    super.initState();
    try{
    if(widget.state != null){
      state = widget.state;
    }else{
      state = new StateModel(isloading: true);
      initUser();
    }
    }catch(e){
      print("\n Exception in init fuction  $e\n\n");
    }
  }

  initUser() async{
    try{
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if(_user != null){
      state.user = _user;
      setState(() {
        state.isloading = false;
        state.user = _user;
      });
    }
    else{
      setState(() {
        state.isloading = false;
      });
    }
    }catch(e){
      print("\n Exception in init user  $e\n\n");
    }

    }

  @override
  Widget build(BuildContext context) {
      return new MyInheritedWidget(
      data: this,
      child: widget.child,
    );
  } 
}

class MyInheritedWidget extends InheritedWidget{
  final _StateWidgetState data;

  MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data
  }):super(key:key , child : child);

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) => true;
  
}