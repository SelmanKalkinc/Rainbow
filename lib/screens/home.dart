import 'dart:math';
import 'package:rainbow/models/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore2 = FirebaseFirestore.instance;

class Home extends StatefulWidget {
  const Home(this.user);
  final String user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController post_text_controller = TextEditingController();

  var randomColor = Random();

  void Send_post() async {
    if (post_text_controller.text != "") {
      await firestore2.collection("posts").doc().set({
        'user_posted': '${widget.user}',
        'post_body': '${post_text_controller.text}',
        'user_liked': '',
        'post_color':
            '${(1000 + randomColor.nextInt(999)).toString() + (1000 + randomColor.nextInt(999)).toString() + (1000 + randomColor.nextInt(999)).toString()}',
      });
      post_text_controller.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("You should type!"),
          duration: const Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: UserInformation(widget.user)),
          TextField(
            controller: post_text_controller,
            decoration: InputDecoration(
                labelText: "Enter text here",
                prefixIcon: Icon(
                  Icons.message,
                  color: Colors.blue,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.deepOrange,
                  ),
                  onPressed: Send_post,
                )),
          )
        ],
      ),
      appBar: AppBar(title: Text("Rainbow : Posts in Colors")),
    );
  }
}
