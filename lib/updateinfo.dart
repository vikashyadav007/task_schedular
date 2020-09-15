import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_schedular/state.dart';
import 'package:task_schedular/state_widget.dart';
import 'Home.dart';
import 'AddTask.dart';


class UpdateInfo extends StatefulWidget{
  bool _isNewSignup;
  UpdateInfo(this._isNewSignup);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateInfoState();
  }
  
}

class UpdateInfoState extends State<UpdateInfo>{

  StateModel appState;
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _errorMessage;
  bool _isLoading;

  bool _validateAndSave(){
    final _form = _formKey.currentState;
    if(_form.validate()){
      _form.save();
      return true;
    }
    else
    return false;

  }
   _validateAndSubmit() async{
    setState(() {
      _errorMessage="";
      _isLoading = true;
    });
    if(_validateAndSave()) {
      try{

        UserUpdateInfo _userUpdateInfo = new UserUpdateInfo();
        _userUpdateInfo.displayName = _name;
        //_userUpdateInfo.photoUrl = "data:image/png;base64,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";

          await appState.user.updateProfile(_userUpdateInfo).then((onValue) async{
            FirebaseUser _user = await FirebaseAuth.instance.currentUser();
                appState.user = _user;
                if(widget._isNewSignup){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTask(true)));
                }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
                }
          }) ;
        
       

      }catch(e){
        print("Error $e");
        setState(() {
          _errorMessage = e;
          _isLoading = false;
          _formKey.currentState.reset();
        });
        
      }
    }

  }

  _showNameInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Update your name",
        ),
         validator: (value)=>value.isEmpty?"Name must not be Empty":null,
         onSaved: (value)=>_name = value.trim(),
      ),
    );
  }

  _showImageUploader(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Row(
        children: <Widget>[
          Text("Select Image"),
          RaisedButton(
            onPressed: null,
            child: Icon(Icons.file_upload),
          ),
        ],
      ),
    );
  }

  _showSubmitButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
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
            _validateAndSubmit();
          },
        ),
      ),
    );
  }

  _showForm(){
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          _showNameInput(),
          _showImageUploader(),
          _showSubmitButton(),
        ],),
      ),

    );

  }

  _showCircularProcess(){
  if(_isLoading){
  return Center(child: CircularProgressIndicator(),);
  }else{
    return Container(height: 0,width: 0,);
  }
  }

  @override
  void initState() {
   
    super.initState();
   setState(() {
      _isLoading = false;
      _errorMessage = "";
   });
  
  }
  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update info"),
      ),
      body:Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProcess(),
      ],
    ));
  }
  
}