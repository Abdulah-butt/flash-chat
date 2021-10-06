
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flash_chat/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'custom_widget.dart';
import 'package:flash_chat/util/style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var _emailField=new TextEditingController();
  var _passwordField=new TextEditingController();
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
                          "LOGIN",
                          style:
                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 60, 60, 0),
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
                    CustomButtom(loginAction, "LOGIN", Colors.blueGrey)

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginAction() async{
    try {
      setState(() {
        showSpinner=true;
      });
      await Firebase.initializeApp();
      final _auth=FirebaseAuth.instance;
      final user = await _auth.signInWithEmailAndPassword(email: _emailField.text, password: _passwordField.text);
      if(user!=null){
        setState(() {
          showSpinner=false;
        });

        Navigator.pushNamed(context, ScreenRoute.chatScreen);
        //Navigator.pushNamed(context, ScreenRoute.uploadScreen);

      }
    }catch(e){
      setState(() {
        showSpinner=false;
      });
      if(e.toString().contains("The password is invalid or the user does not have a password")||e.toString().contains("There is no user record corresponding to this identifier")){
        Alert(
          context: context,
          title: "Error",
          desc: "Email/Password is Incorrect",
          closeIcon: Icon(Icons.clear),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],

        ).show();
      }else{
        print("error is $e");
      }
    }

  }
}


