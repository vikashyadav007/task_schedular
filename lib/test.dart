import 'package:flutter/material.dart';

class Test extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
  
}

class TestState extends State<Test>{
  @override
  Widget build(BuildContext context) {
  
  var scaffold = Scaffold(
    appBar: AppBar(
      title: Text("Test"),
    ),
    body: Text("Test Page"),
  );

    return scaffold;
  }

}