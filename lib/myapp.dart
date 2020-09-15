import 'package:flutter/material.dart';
import 'package:task_schedular/Home.dart';
import 'Home.dart';
import 'Login.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Task Schedular',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context)=>Home(),
        '/Login':(context) => Login(),
      },
    );
  }

}