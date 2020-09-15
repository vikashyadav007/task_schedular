import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_schedular/additionalTaskDetails.dart';
import 'Home.dart';

class ShowAdditionalTask extends StatefulWidget{
  FirebaseUser _user;
  ShowAdditionalTask(this._user);
  @override
  State<StatefulWidget> createState() {
    return ShowAdditionalTaskState(this._user);
  }
}

class ShowAdditionalTaskState extends State<ShowAdditionalTask>{

  FirebaseUser _user;
  ShowAdditionalTaskState(this._user);
   bool _isloading = false;
  String todayDate;
  List _todayTasks=[];
  Map _completeData={};

  var _tapPosition;

  List<Widget> _getTaskTile(List list){
      List<Widget> widget=[];
           if(list.isEmpty){
        widget.add(Center(child: Text("No data"),));
      }
      else{   
     for(int i=0;i<list.length;i++){
       var _padding = Padding(
         padding: EdgeInsets.all(6),
         child: GestureDetector(
          onTapDown: (TapDownDetails details){
            _tapPosition = details.globalPosition;

          },
           onLongPress: (){
             final RenderBox overlay = Overlay.of(context).context.findRenderObject();
             showMenu(
                context: context,
             position: RelativeRect.fromRect(_tapPosition & Size(40,40), Offset.zero & overlay.size),
               items: <PopupMenuEntry>[
                 PopupMenuItem(
                   value: "loda",
                   child: GestureDetector(
                     onTap: ()async{
                       Navigator.of(context).pop();
                        setState(() {
                           _isloading = true;
                         });   
                       await Firestore.instance.collection(_user.uid.toString())
                       .document('Additional_task').updateData({list[i]:FieldValue.delete()})
                       .whenComplete(() async{
                         await Firestore.instance.collection(_user.uid.toString())
                       .document('AdditionalTaskLearning').updateData({list[i]:FieldValue.delete()})
                       .whenComplete((){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowAdditionalTask(_user)));
                       });
                       });   
                     },
                     
                     child:
                     Row(
                     children: <Widget>[
                       Icon(Icons.delete),
                       Text("Delete"),
                     ],
                   ),
                   )
                 ),
               ],
             );
           },
           onTap: (){
             Navigator.of(context).
             push(MaterialPageRoute(
               builder: (context)=>AdditionalTaskDetails(_user,list[i])));
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

     _fetchFirestoreData() async{
    setState(() {
      _isloading = true;
    });
    var data =  Firestore.instance.collection(_user.uid.toString()).document('Additional_task');
    data.get().then((value){
       if(value.data == null){
         setState(() {
           _isloading = false;
         });
        }
        else{
          setState(() {
           _todayTasks = value.data.keys.toList();
           _completeData = value.data;   
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
        title: Text("Additional Task"),
      ),
      body: _builtContainer(),
    )
    );
  }

}