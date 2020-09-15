import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'myDateTime.dart';
import 'dart:convert';
import 'taskHandler.dart';


class TaskDetails extends StatefulWidget{
  DateTime _selectedDate;
  FirebaseUser _user;
  String _task;

  TaskDetails(this._selectedDate,this._user,this._task);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskDetailsState(this._selectedDate,this._user,this._task);
  }
} 

class TaskDetailsState extends State<TaskDetails>{
  DateTime _selectedDate;
  FirebaseUser _user;
  String _task;
  bool _isloading;
  bool _isformSubmitted;
  TaskDetailsState(this._selectedDate,this._user,this._task);

  TextEditingController _topic = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  String _learningTopic;
  String _learningDescription;

  @override
  void initState() {
    super.initState();
    _isloading = false;
    _checkIfSubmitted();
  }

  _changeWorkDone() async {
    Map _todayTasks; 
    await Firestore.instance.collection(_user.uid).document('work done')
      .collection(thisWeekend(_selectedDate.day, _selectedDate.weekday, _selectedDate.month, _selectedDate.year))
    .document(_selectedDate.day.toString()+monthString[_selectedDate.month]+_selectedDate.year.toString())
    .get().then((value){
      print(value.data);
         _todayTasks = value.data;
          _todayTasks['default_task'][_task.toString()]=true;
    });
    await Firestore.instance.collection(_user.uid).document('work done')
      .collection(thisWeekend(_selectedDate.day, _selectedDate.weekday, _selectedDate.month, _selectedDate.year))
    .document(_selectedDate.day.toString()+monthString[_selectedDate.month]+_selectedDate.year.toString())
    .setData(_todayTasks).then((onValue){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskHandler(_selectedDate,_user)));
    });
  }

  _showLearning(){
    return Center(
      child: ListView(
        children: <Widget>[
          Center(child:Text(_learningTopic,style:TextStyle(fontSize: 30,color:Colors.black87))),
          Padding(padding: EdgeInsets.fromLTRB(2, 50, 2, 2),
          child: Center(child:Text(_learningDescription,style:TextStyle(fontSize: 20,color:Colors.blue)),))
        ],
      ),
    );
  }


  _formSubmitContainer(){
    return ListView(
          children: <Widget>[
           Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child:
        TextFormField(
          controller: _topic,
          autofocus: false,
          keyboardType: TextInputType.text,
          minLines: 2,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Enter Topic of your learning.",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            )
          ),
        ),
        ),
            Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child:
        TextFormField(
          controller: _description,
          autofocus: false,
          keyboardType: TextInputType.text,
          minLines: 5,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Enter breif description of your learning",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
            )
          ),
        ),
        ),

         Padding(
      padding: EdgeInsets.fromLTRB(8, 25, 8, 0),
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
             setState(() {
              _isloading = true;
            });
           _submitLearning();
           _changeWorkDone();
          },
        ),
      ),
    ),
          ],
        );
  }

  _showCircularProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  _submitLearning() async{
    Map<String,String> map = {
      _topic.text:_description.text,
    };
    DocumentReference dr = await Firestore.instance.collection(_user.uid.toString()).document('learning')
    .collection(_selectedDate.day.toString()+monthString[_selectedDate.month]+_selectedDate.year.toString())
    .document(_task);
    dr.setData(map);
  }
  _checkIfSubmitted() async{
    setState(() {
      _isloading = true;
    });
    await Firestore.instance.collection(_user.uid.toString()).document('learning')
    .collection(_selectedDate.day.toString()+monthString[_selectedDate.month]+_selectedDate.year.toString())
    .document(_task).get().then((value){
      if(value.data == null){
       setState(() {
         _isformSubmitted = false;
         _isloading = false;
       });
      }else
      {
         setState(() {
         _isformSubmitted = true;
         _isloading = false;
         _learningTopic = value.data.keys.toList()[0].toString();
         _learningDescription = value.data.values.toList()[0].toString();
       });
       
        return Text(value.data.toString());
      }
    });

  }


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: Text("Submit task"),),
      body: Stack(
        children: <Widget>[
          Center(
        child: _isloading?
        _showCircularProgress():
        _isformSubmitted?_showLearning():_formSubmitContainer(),
      ),
        ],
      )  
    );
  }
  
}