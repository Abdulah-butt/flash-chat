




import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/model/myModel.dart';
import 'package:flash_chat/ui/uploadImage.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/ui/welcome_screen.dart';
import 'package:flash_chat/ui/login_screen.dart';
import 'package:flash_chat/ui/registration_screen.dart';
import 'package:flash_chat/ui/chat_screen.dart';
import 'package:flash_chat/ui/routes.dart';
import 'package:provider/provider.dart';


void main(){

  runApp(
      new MaterialApp(
        title: "Flash Chat",
        initialRoute: ScreenRoute.welcomeScreen,
        routes: {
          ScreenRoute.welcomeScreen:(context)=>WelcomeScreen(),
          ScreenRoute.loginScreen:(context)=>LoginScreen(),
          ScreenRoute.registrationScreen:(context)=>RegistrationScreen(),
          ScreenRoute.chatScreen:(context)=>ChatScreen(),
          ScreenRoute.uploadScreen:(context)=>MyHomePage(),

        },
      ));
}