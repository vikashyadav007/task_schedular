import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myDateTime.dart';
import 'taskDetails.dart';
import 'Home.dart';


class TaskHandler extends StatefulWidget{
  DateTime selectedDate;
  FirebaseUser _user;
  TaskHandler(this.selectedDate,this._user);
  @override
  State<StatefulWidget> createState() {
    return TaskHandlerState(selectedDate,_user);
  }
}

class TaskHandlerState extends State<TaskHandler>{
  DateTime seletctedDate;
  FirebaseUser _user;
  TaskHandlerState(this.seletctedDate,this._user);
  bool _isloading = false;
  String todayDate;
  List _todayTasks=[];
  Map _completeData={};

   List<Widget> _getTaskTile(List list){
      List<Widget> widget=[];
           if(list.isEmpty){
        widget.add(Center(child: Text("No data due to weekend"),));
      }
      else{   
     for(int i=0;i<list.length;i++){
       var _padding = Padding(
         padding: EdgeInsets.all(6),
         child: GestureDetector(
           onTap: (){
             Navigator.of(context).
             push(MaterialPageRoute(
               builder: (context)=>TaskDetails(seletctedDate,_user,list[i])));
           },
           child: 
           Chip(
           elevation: 5,
           label: Container(
             width: 250,
             height:40,
             child:Center(child:Text(list[i],style: TextStyle(fontSize: 25,color: Colors.black54),),)),
            backgroundColor: (_completeData[list[i]]==true?Colors.green[200]:Colors.red[200]),
           avatar: CircleAvatar(
           backgroundColor: Colors.grey.shade100,
           child: Icon(_completeData[list[i]]==true?Icons.assignment_turned_in:Icons.assignment_late,
           color: _completeData[list[i]]==true?Colors.blue[200]:Colors.black54),
           ),
         ),)
         );
         widget.add(_padding);
     }
      }
      return widget;
    }

  _createFirestoreData() async{
    bool _isWorkingDay;
     List<String> _tasks;
      await Firestore.instance.collection(_user.uid.toString()).document('Working Days').
            get().then((value){
                    _isWorkingDay =  value.data[weekString[seletctedDate.weekday]];
               });
     if(_isWorkingDay){
          Map<String,bool> task_map ={};
          Map<String,Map<String,bool>> final_map={};
     await Firestore.instance.collection(_user.uid.toString()).document('tasks')
           .get().then((value){
                  _tasks = value.data.keys.toList();
                  _tasks.forEach((f){
                  task_map[f]=false;
                      }); 
            });
       final_map['default_task']=task_map;
       setState(() {
         _todayTasks = final_map['default_task'].keys.toList();
         _isloading = false;
         _completeData = final_map['default_task'];
       });
      DocumentReference dr = await Firestore.instance.collection(_user.uid).document('work done')
      .collection(thisWeekend(seletctedDate.day, seletctedDate.weekday, seletctedDate.month, seletctedDate.year))
    .document(todayDate);
    await dr.setData(final_map);
     }
     else{

       //Code for non working days
        setState(() {
       _isloading = false;
     });
     }
  }

  _fetchFirestoreData() async{
    setState(() {
      _isloading = true;
    });
      todayDate = seletctedDate.day.toString() + monthString[seletctedDate.month]+seletctedDate.year.toString();
    var data =  Firestore.instance.collection(_user.uid.toString()).document('work done')
    .collection(thisWeekend(seletctedDate.day, seletctedDate.weekday, seletctedDate.month, seletctedDate.year))
    .document(todayDate);
    data.get().then((value){
       if(value.data == null){
          _createFirestoreData();
        }
        else{
          setState(() {
           _todayTasks = value.data['default_task'].keys.toList();
           _completeData = value.data['default_task'];   
             _isloading = false;
          });
        }
    });
  }

  @override
  void initState() {
    super.initState();
    _isloading = false;
     _fetchFirestoreData();
  }

  Center _showCircularProgress(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _builtContainer(){
    if(_isloading==true){
     return _showCircularProgress();
    }else{
     return _showOriginal();
    }
  }
  Widget _showOriginal(){
    return _isloading?_showCircularProgress():
    Center(
      child: ListView(
        children: _getTaskTile(_todayTasks)
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
      onWillPop: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
      },

  child:
    Scaffold(
      appBar: AppBar(
        title: Text("Task Handler"),
      ),
      body: _builtContainer(),
    )
    );
  }
  
}
