import 'package:rainbow/screens/home.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController name_controller = TextEditingController();
TextEditingController password_controller = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  void go_to_register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void login() async {
    FocusScope.of(context).unfocus();
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('users')
          .doc('${name_controller.text}')
          .get();
      if (documentSnapshot.exists) {
        var _data = new Map<String, dynamic>.from(
            (documentSnapshot.data()) as Map<dynamic, dynamic>);

        if (_data["password"] == password_controller.text) {
          String user = documentSnapshot.id;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home(user)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Password not correct!"),
              duration: const Duration(seconds: 2)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("User not found!"),
            duration: const Duration(seconds: 2)));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 150, 10, 10),
            child: TextField(
              controller: name_controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Enter your name:",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.orange)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: password_controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Enter your password:",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.orange)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(fixedSize: Size(90, 50)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: go_to_register,
              child: Text("Sign Up"),
              style: ElevatedButton.styleFrom(fixedSize: Size(90, 50)),
            ),
          )
        ],
      ),
    );
  }
}
