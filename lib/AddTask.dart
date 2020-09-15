import 'package:flutter/material.dart';
import 'package:task_schedular/Home.dart';
import 'package:task_schedular/addWorkingDays.dart';
import 'package:task_schedular/state.dart';
import 'package:task_schedular/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddTask extends StatefulWidget{
  bool _isNewSignup;
  AddTask(this._isNewSignup);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddTaskState();
  }
}

class AddTaskState extends State<AddTask>{
    TextEditingController _task = new TextEditingController();
    List<String> _taskList =[];
    StateModel appState;
    Widget _showBody;
    bool _update=true;
    bool _isTap = false;
    var _column,_menu;

    List<Widget> _getTaskTile(List<String> list){
      List<Widget> widget=[];
    
     for(int i=0;i<list.length;i++){
       var _padding = Padding(
         padding: EdgeInsets.all(4),
         child: Chip(
           label: Container(
             width: 150,
             height: 45,
             child:Center(child:Text(list[i],style: TextStyle(fontSize: 25,color: Colors.black54),),)),
            avatar: CircleAvatar(
           backgroundColor: Colors.grey.shade100,
           child: Icon(Icons.thumb_up,color: Colors.grey,),
           ),
           
           backgroundColor: Colors.green[200],
         ),
         );
         widget.add(_padding);
     }
      return widget;
    }
    _submit() async{
            if(_taskList.isNotEmpty){
             Map<String,String> _data ={};
              _taskList.forEach((f){
                _data[f]=f;
              });
               DocumentReference dr;
              
               if(widget._isNewSignup){
                  dr = Firestore.instance.
               collection(appState.user.uid.toString()).document('tasks');
               dr.setData(_data);

              Navigator.of(context).
             push(MaterialPageRoute(builder:(context)=>AddWorkingDay()));
               }else
               if(_update){
                dr = Firestore.instance.
               collection(appState.user.uid.toString()).document('tasks');
               dr.updateData(_data);
                Navigator.of(context).
                 push(MaterialPageRoute(builder:(context)=>Home()));
               }
               else
               if(!_update)
               {
                 Map<String,bool> _data ={};
                 _taskList.forEach((f){
                _data[f]=false;
                });

                  dr = Firestore.instance.
               collection(appState.user.uid.toString()).document('Additional_task');

               await dr.get().then((value){
                 if(value.data == null){
                   dr.setData(_data);
                 }else{
                   dr.updateData(_data);
                 }

               });
                   Navigator.of(context).
             push(MaterialPageRoute(builder:(context)=>Home()));
               }
            }
    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  } 
  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    
     _column =ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child:
        TextFormField(
          controller: _task,
          autofocus: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Enter Task",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28)
            )
          ),
        )),
         Padding(padding: EdgeInsets.all(8),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          color: Colors.blue,
          child: Text("Add Task",style: TextStyle(fontSize: 20,color: Colors.white),),
          onPressed: (){
            if(_task.text!=""){
            setState(() {
             _taskList.add(_task.text);
             _task.text="";
          });
            }
          },
        ),
      ),
    ),


     Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
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
            _submit();
          },
        ),
      ),
    ),
          ],
        ),
       Padding(padding: EdgeInsets.all(8),),
       Container(
         height: 500,
         child: ListView(
           children: _getTaskTile(_taskList)
         ),
       ),
       
      ],
    );

    _menu = Center(
    child: ListView(
        children: <Widget>[
          Padding(
      padding: EdgeInsets.fromLTRB(30, 200, 30, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          color: Colors.blue,
          child: Text("Add default Task",style: TextStyle(fontSize: 20,color: Colors.white),),
          onPressed: (){
            setState(() {
              _showBody = _column;
              _update = true;
              _isTap = true;
            });
          },
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
      child: SizedBox(
        height: 40,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          color: Colors.blue,
          child: Text("Additional Tasks",style: TextStyle(fontSize: 20,color: Colors.white),),
          onPressed: (){
            setState(() {
              _showBody = _column;
              _update = false;
              _isTap = true;
            });
           
          },
        ),
      ),
    ),
],
  ),);

setState(() {
   _showBody = widget._isNewSignup?_column:_isTap?_column:_menu;
});  
    var _scaffold = Scaffold(
      appBar: AppBar(title: Text("Add Task"),),
      body: _showBody,
    );
    return _scaffold;
  }
  
}