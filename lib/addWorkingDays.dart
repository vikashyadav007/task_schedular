import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_schedular/state.dart';
import 'package:task_schedular/state_widget.dart';
import 'Home.dart';

class AddWorkingDay extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddWorkingDayState();
  }
  
}

class AddWorkingDayState extends State<AddWorkingDay>{

  StateModel appState;
  List<String> _weekDays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  List<String> _selected_item = List();
  List<String> _selected_list_item;

 _displayWeekDays(List<String> list){
   List<Widget> _choices = List();

   list.forEach((item){
     _choices.add(Container(
       padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
       child: ChoiceChip(
         label: Container(
             width: 200,
             height:45,
             child:Center(child:Text(item,style: TextStyle(fontSize: 25,color: Colors.black54),),)),
              avatar: CircleAvatar(
           backgroundColor: Colors.grey.shade100,
           child: Icon(_selected_item.contains(item)?Icons.check_box:Icons.check_box_outline_blank,
           color: Colors.black54,),
           ),
         labelStyle: TextStyle(fontSize: 20),
         selected: _selected_item.contains(item),
         onSelected: (selected){
           _selected_item.contains(item)?_selected_item.remove(item):_selected_item.add(item);
           setState(() {
             _selected_list_item = _selected_item;
           });
         },
         selectedColor: Colors.green[300],
         backgroundColor: Colors.green[100],
       ),
     ));
   });
   return _choices;
 }

  @override
  Widget build(BuildContext context) {
   
   appState = StateWidget.of(context).state;
   
    return Scaffold(
      appBar: AppBar(title: Text("select week days"),),
      body: Center(child: ListView(
        children: <Widget>[
          Column(children:_displayWeekDays(_weekDays)),
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),),

         Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          color: Colors.blue,
          child: Text("Submit",style: TextStyle(fontSize: 20,color: Colors.white),),
          onPressed: (){

             print("\n\nSelected item is $_selected_list_item\n\n");
              Map<String,bool> map = {};
               _weekDays.forEach((item){
                 map[item]=false;
               });
              _selected_list_item.forEach((item){
                map[item]=true;
              });

              DocumentReference df = Firestore.instance.
              collection(appState.user.uid.toString()).document("Working Days");
              df.setData(map);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
           
          },
        ),
      ),
    ),

        ],
      ),),
    );
  }
  
}