
import 'package:flash_chat/ui/routes.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'custom_widget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=new AnimationController(duration: Duration(seconds: 2), vsync: this, upperBound: 50);
    animation=ColorTween(begin: Colors.red,end: Colors.yellow).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });

  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: animation.value,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'icon',
                  child: new Icon(
                    Icons.flash_on,
                    color: Colors.orange,
                    size:controller.value,
                  ),
                ),
                new TypewriterAnimatedTextKit(
                  text:["Flash Chat"],
                  textStyle: new TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  speed: const Duration(milliseconds: 100),
                )
              ],
            ),
            SizedBox(height:size.height*0.06,),
            CustomButtom(RouteToLogin, "LOGIN",Colors.blueGrey),
            CustomButtom(RouteToRegistration, "Registration",Colors.blueAccent),

          ],
        ),
      ),
    );
  }

  void RouteToLogin(){
    Navigator.pushNamed(context, ScreenRoute.loginScreen);
  }
  void RouteToRegistration(){
    Navigator.pushNamed(context, ScreenRoute.registrationScreen);
  }
}
