import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/ui/custom_widget.dart';
import 'package:flash_chat/ui/routes.dart';
import 'package:flash_chat/util/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

final _firestore=FirebaseFirestore.instance;

class _RegistrationScreenState extends State<RegistrationScreen> {

  var _emailField=new TextEditingController();
  var _passwordField=new TextEditingController();
  var _fullNameField=new TextEditingController();
  var _fatherNameField=new TextEditingController();

  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    Size buttonSize=new Size(size.width*0.7,size.height*0.05);
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall:showSpinner,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'icon',
                          child: new Icon(
                            Icons.flash_on,
                            color: Colors.orange,
                            size: 50,
                          ),
                        ),
                        new Text(
                          "REGISTER",
                          style:
                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(60, 60, 60, 0),
                        child: new TextFormField(
                          controller: _fullNameField,
                          decoration: kInputDecoration.copyWith(labelText: "Full Name",icon:Icon(Icons.person_outline)),
                          keyboardType: TextInputType.name,
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                        child: new TextFormField(
                          controller: _fatherNameField,
                          decoration: kInputDecoration.copyWith(labelText: "Father Name",icon:Icon(Icons.person_pin)),
                          keyboardType: TextInputType.name,
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                        child: new TextFormField(
                          controller: _emailField,
                          decoration: kInputDecoration,
                          keyboardType: TextInputType.emailAddress,
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                      child: new TextFormField(
                        controller: _passwordField,
                        decoration:kInputDecoration.copyWith(labelText: "Password",icon: Icon(Icons.vpn_key_sharp)),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: size.height*0.05,),
                    CustomButtom(RegisterAction, "REGISTER", Colors.blue)

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void RegisterAction() async{
    try {
      setState(() {
        showSpinner=true;
      });
      await Firebase.initializeApp();
      final _auth=FirebaseAuth.instance;
      final user = await _auth.createUserWithEmailAndPassword(email: _emailField.text, password: _passwordField.text);
      _firestore.collection('registrations').add({
        'name':_fullNameField.text,
        'father_name':_fatherNameField.text,
        'email':_emailField.text,
        'password':_passwordField.text
      });
      if(user!=null){
        setState(() {
          showSpinner=false;
        });
        Navigator.pushNamed(context, ScreenRoute.chatScreen);
      }
    }catch(e){
      print(e);
    }
  }
}
