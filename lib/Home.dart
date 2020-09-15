import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_schedular/Login.dart';
import 'package:task_schedular/addWorkingDays.dart';
import 'package:task_schedular/showAdditionalTask.dart';
import 'package:task_schedular/showDefaultTask.dart';
import 'state.dart';
import 'package:task_schedular/services/authentication.dart';
import 'state_widget.dart';
import 'Login.dart';
import 'updateinfo.dart';
import 'AddTask.dart';
import 'package:table_calendar/table_calendar.dart';
import 'taskHandler.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>{
  StateModel appState;
  Auth auth = new Auth();
  CalendarController _calendarController ;
  bool _isloading;

  _drawer(){
    var style = TextStyle(fontSize: 20, color: Colors.black54);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: appState.user.photoUrl ==null?AssetImage('assets/download.png'):
                              NetworkImage(appState.user.photoUrl)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Text(
                        appState.user.displayName,
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Text(appState.user.email,
                          style: TextStyle(fontSize: 12, color: Colors.white60))
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.blue[300]),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(children: <Widget>[
 
            Container(
              //color: Colors.green[200],
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Update Info',
                      style: style,
                    ),
                    trailing: Icon(Icons.info),
                    onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateInfo(false)));
                    },
                  ),
                  Divider(
                    height: 4,
                  ),
                  ListTile(
                    title: Text(
                      'Add Task',
                      style: style,
                    ),
                    trailing: Icon(Icons.note_add),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTask(false)));
                    },
                  ),
                   Divider(
                    height: 4,
                  ),
                  ListTile(
                    title: Text(
                      'Show Default task',
                      style: style,
                    ),
                    trailing: Icon(Icons.assignment),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowDefaultTask(appState.user)));
                    },
                  ),
                  Divider(
                    height: 4,
                  ),
                   ListTile(
                    title: Text(
                      'Update Working Days',
                      style: style,
                    ),
                    trailing: Icon(Icons.work),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddWorkingDay()));
                    },
                  ),
                  Divider(
                    height: 4,
                  ),
                   ListTile(
                    title: Text(
                      'Show Additional Tasks',
                      style: style,
                    ),
                    trailing: Icon(Icons.assignment),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowAdditionalTask(appState.user)));
                    },
                  ),
                  Divider(
                    height: 4,
                  ),
                  ListTile(
                    title: Text(
                      'Contact us',
                      style: style,
                    ),
                    trailing: Icon(Icons.phone),
                  ),
                  Divider(
                    height: 4,
                  ),
                  ListTile(
                    title: Text(
                      'About us',
                      style: style,
                    ),
                    trailing: Icon(Icons.account_circle),
                  ),
                  
                  Divider(
                    height: 4,
                  ),
                ],
              ),
            ),
             ],),
            flex: 5,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10),
                color: Colors.blue[300],
                child: FlatButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    },
                    child: ListTile(
                      title: Text(
                        'Log out',
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                      trailing: Icon(Icons.power_settings_new),
                    )),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _dayPressed(DateTime date, List list){
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskHandler(date,appState.user)));
    
  }


   _tableCalendar(){
     return TableCalendar(
       startingDayOfWeek: StartingDayOfWeek.monday,
       calendarController: _calendarController,
      endDay: DateTime.now(),
      startDay: appState.user.metadata.creationTime,
      initialCalendarFormat: CalendarFormat.month,
      headerVisible: true,
      onDaySelected: _dayPressed,
     // onDayLongPressed: _dayPressed(),
      
     );
   }

    Widget _buildstory({Widget body}){
      return 
      Scaffold(
        drawer: _drawer(),
    appBar: AppBar(
      title: Text("Home"),
    ),
    body:
    WillPopScope(
      onWillPop: (){
        exit(0);
      },
      child:
      Center(
      child: ListView(
        children: <Widget>[
          _tableCalendar(),
        ],
      ),
    )
    )
    );
    }

    Widget _buildContent(){
      if(appState.isloading==true){
        return _buildLoadingContainer();
      }else
      if(!appState.isloading && appState.user==null){
        return new Login();
      }else{
        return _buildstory();
      }
    }

   Widget  _buildLoadingContainer(){
      return Scaffold(
        body:WillPopScope(
          onWillPop: (){
            exit(0);
          },
          child: 
        Center(
        child: CircularProgressIndicator(),
      )));
    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    
  appState = StateWidget.of(context).state;
  return _buildContent();
  }

}