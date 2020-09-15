import 'package:flutter/material.dart';
import 'myapp.dart';
import 'state_widget.dart';

main(){
  StateWidget stateWidget = new StateWidget(child: new MyApp());
  try{
  runApp(stateWidget);
  }catch(e){
    print("Error in main function : $e\n\n");
  }
}



