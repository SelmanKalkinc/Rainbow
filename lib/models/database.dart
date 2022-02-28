import 'package:rainbow/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream collectionStream =
    FirebaseFirestore.instance.collection('posts').snapshots();
Stream documentStream =
    FirebaseFirestore.instance.collection('posts').doc().snapshots();

class UserInformation extends StatefulWidget {
  final String name;
  const UserInformation(this.name);
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            Set liked_users = {};

            Future<void> appendToArray(String id, dynamic element) async {
              firestore2.collection('posts').doc(id).update({
                'user_liked': FieldValue.arrayUnion([element]),
              });
            }

            Future<void> removeFromArray(String id, dynamic element) async {
              firestore2.collection('posts').doc(id).update({
                'user_liked': FieldValue.arrayRemove([element]),
              });
            }

            void _like() async {
              if (liked_users.contains('${widget.name}')) {
                removeFromArray(document.id, '${widget.name}');
              } else {
                appendToArray(document.id, '${widget.name}');
              }

              try {} catch (e) {}
            }

            Color post_color;
            post_color = Color(int.parse(data['post_color']));
            print(post_color);
            print(data['post_color']);

            if (data['user_liked'] != "") {
              for (String member in data['user_liked']) {
                liked_users.add(member);
              }
            }
            return Card(
              color: post_color,
              child: Row(children: <Widget>[
                Expanded(
                    child: ListTile(
                  title: Text(data['post_body']),
                  subtitle: Text(data['user_posted']),
                )),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(liked_users.length.toString()),
                    ),
                    IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.favorite),
                        onPressed: _like,
                        color: liked_users.contains('${widget.name}')
                            ? Colors.red
                            : Colors.black)
                  ],
                )
              ]),
            );
          }).toList(),
        );
      },
    );
  }
}
