import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_schedular/showAdditionalTask.dart';
import 'myDateTime.dart';

class AdditionalTaskDetails extends StatefulWidget{
  FirebaseUser _user;
  String _task;

  AdditionalTaskDetails(this._user,this._task);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdditionalTaskDetailsState(this._user,this._task);
  }
}

class AdditionalTaskDetailsState extends State<AdditionalTaskDetails>{
  FirebaseUser _user;
  String _task;
  AdditionalTaskDetailsState(this._user,this._task);

  bool _isLoading;
  bool _isFormSubmitted;
  String _learningTopic;
  String _learningDescription;
  bool _containsSomeData;

  TextEditingController _topic = TextEditingController();
  TextEditingController _description = TextEditingController();


  _changeWorkDone() async {
    Map _todayTasks; 
    await Firestore.instance.collection(_user.uid).document('Additional_task')
     .get().then((value){
      print(value.data);
         _todayTasks = value.data;
         _todayTasks[_task]=true; 

         print(_todayTasks);
    });
    await Firestore.instance.collection(_user.uid).document('Additional_task')
    .updateData(_todayTasks).then((onValue){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowAdditionalTask(_user)));
    });
  }



  _showCircularProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

   _checkIfSubmitted() async{
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.collection(_user.uid.toString()).document('AdditionalTaskLearning')
    .get().then((value){
      if(value.data == null){
       setState(() {
         _isFormSubmitted = false;
         _isLoading = false;
         _containsSomeData = false;
       });
      }else
      {

        if(value.data.keys.contains(_task)){
          print("\n\n\nThis condition is true");

          Map fetchedData = value.data;
          Map d = fetchedData[_task];
           setState(() {
         _isFormSubmitted = true;
         _isLoading = false;
         _containsSomeData = true;
         _learningTopic = d.keys.toList()[0].toString();
         _learningDescription = d.values.toList()[0].toString();
       });
        }else{
          setState(() {
             _isFormSubmitted = false;
             _isLoading = false;
             _containsSomeData = true;
          });
        }
        
        return Text(value.data.toString());
      }
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

   _submitLearning() async{
     Map<String,Map<String,String>> complete_map={};
    Map<String,String> map = {
      _topic.text:_description.text,
    };
    complete_map[_task]=map;
    DocumentReference dr = await Firestore.instance.collection(_user.uid.toString())
    .document('AdditionalTaskLearning');

    if(_containsSomeData){
      dr.updateData(complete_map);
    }else{
    dr.setData(complete_map);
    }
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
              _isLoading = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _checkIfSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additional Task Details"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: _isLoading?
        _showCircularProgress():
        _isFormSubmitted?_showLearning():_formSubmitContainer(),
          )
        ],
      ),
    );
  }
  
}