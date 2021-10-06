import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/model/myModel.dart';

import 'package:flash_chat/ui/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/util/style.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var message = new TextEditingController();

  @override
  void initState() {
    GetAllNames().whenComplete(() {
      setState(() {});
    });
    super.initState();
    getUser();
  }

  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  late User loggInUser;
  bool isMe = false;
  var Current_user;
  var Current_UserName;
  bool showSpinner = false;

  void getUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggInUser = user;
        Current_user = loggInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  List<Map> userNameMap = [];

  Future GetAllNames() async {
    final CollectionReference _reference =
        await _firestore.collection('registrations');

    try {
      await _reference.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          userNameMap.add({'name': element['name'], 'email': element['email']});
        });
      });
    } catch (e) {
      print("Errrr");
    }
  }

  String GetNameFromEmail(String email) {
    print("length is ${userNameMap.length}");
    for (int i = 0; i < userNameMap.length; i++) {
      print(userNameMap[i]['email']);
      if (userNameMap[i]['email'] == email) {
        return userNameMap[i]['name'];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.orange,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(
                Icons.flash_on_rounded,
                color: Colors.orange,
                size: 25,
              ),
              new Text(
                " Flash Chat",
                style: new TextStyle(color: Colors.black),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            new IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.orange,
                )),
          ],
          backgroundColor: Colors.white,
        ),
    
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    showSpinner = false;
                    final documents = snapshot.data!.docs;

                    List<Widget> msgWidgets = [];
                    for (var message in documents) {
                      final msgText = message['text'];
                      final msgSender = message['sender'];
                      final user = GetNameFromEmail(msgSender);
                      var currentUser = loggInUser.email;

                      if (msgSender == currentUser) {
                        isMe = true;
                      } else {
                        isMe = false;
                      }

                      final msgWidget =
                          CustomMessageWidget(msgText, user, isMe);
                      msgWidgets.add(msgWidget);
                    }

                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: new EdgeInsets.all(10),
                        children: msgWidgets,
                      ),
                    );
                  } else {
                    showSpinner = true;

                    return Container();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: new TextField(
                        controller: message,
                        decoration: kInputDecoration.copyWith(
                            labelText: "Type Message here",
                            focusColor: Colors.white),
                      ),
                    ),
                    new IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _firestore.collection('messages').add({
                          'text': message.text,
                          'sender': Current_user,
                          'timestamp': Timestamp.now(),
                        });
                        message.clear();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
