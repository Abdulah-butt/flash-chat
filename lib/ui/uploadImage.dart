import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/model/myModel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

UploadTask? task;
File? file;

String? urlDownload;
class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selected Image'),

            RaisedButton(
              child: Text('Choose File'),
              onPressed:selectFile ,
              color: Colors.cyan,
            ),
           RaisedButton(
              child: Text('Upload File'),
              onPressed:uploadFile,
              color: Colors.cyan,
            ),
           RaisedButton(
              child: Text('Clear Selection'),
              onPressed: clearSelection,
            ),
            Text('Uploaded Image'),
            urlDownload==null?new Container():new CircleAvatar(
              backgroundImage: NetworkImage('$urlDownload'),
            )

          ],
        ),
      ),
    );
  }



  Future selectFile() async {
    await Firebase.initializeApp();
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    print("started");
    if (file == null){
     print("null file is");
    }

    final fileName = file!.path;
    final destination = 'images/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null){
      print("task is null");
    }

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      
    });
    print('Download-Link: $urlDownload');
  }


  void clearSelection() {
    setState(() {

    });
  }

}
