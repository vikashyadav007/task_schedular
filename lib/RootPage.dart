import 'package:flutter/material.dart';
import 'package:task_schedular/services/authentication.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}


class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage(this.auth);
  @override
  State<StatefulWidget> createState() {
    return RootPageState();
  }
}

class RootPageState extends State<RootPage>{

  AuthStatus status = AuthStatus.NOT_DETERMINED;
  String _userId;

   @override
  void initState() {
    
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

