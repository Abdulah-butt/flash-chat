
import 'package:flash_chat/model/myModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButtom extends StatelessWidget {
  String btn_label;
  Color _color;
  Function _function;

  CustomButtom(this._function, this.btn_label, this._color);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Size btnSize = new Size(size.width * 0.7, size.height * 0.07);
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
      child: new ElevatedButton(
        onPressed: () {
          _function();
        },
        child: new Text("$btn_label"),
        style: ElevatedButton.styleFrom(
            primary: _color, shape: StadiumBorder(), minimumSize: btnSize),
      ),
    );
  }
}

class CustomMessageWidget extends StatelessWidget {
  late String message;
  late String sender;
  late bool isMe;

  CustomMessageWidget(this.message,this.sender,this.isMe);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          new Text(
            isMe?"":"$sender",
            style: new TextStyle(color: Colors.blueGrey),),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child:Text("$message"),
            ),
            color: isMe?Colors.white:Colors.orange,
          ),
        ],
      ),
    );
  }
}
