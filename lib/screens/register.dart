import 'package:rainbow/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();

  void _create() async {
    FocusScope.of(context).unfocus();
    if (password_controller.text == confirm_password_controller.text) {
      try {
        DocumentSnapshot documentSnapshot;

        documentSnapshot = await firestore
            .collection('users')
            .doc('${name_controller.text}')
            .get();
        if (documentSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("User already exist!"),
              duration: const Duration(seconds: 2)));
        } else {
          await firestore
              .collection("users")
              .doc("${name_controller.text}")
              .set({'password': '${password_controller.text}'});

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } catch (e) {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Password not match!"),
          duration: const Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Register Page"),
      ),
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
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: confirm_password_controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Confirm your password:",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 10, color: Colors.orange)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _create,
              child: Text("Sign Up"),
              style: ElevatedButton.styleFrom(fixedSize: Size(90, 50)),
            ),
          ),
        ],
      ),
    );
  }
}
