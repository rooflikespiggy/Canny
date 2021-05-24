import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDiscussion extends StatefulWidget {
  @override
  _AddDiscussionState createState() => _AddDiscussionState();
}

class _AddDiscussionState extends State<AddDiscussion> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dbRef = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget> [
                Text(
                  'Discuss in the Forum!',
                  style: TextStyle(fontSize: 23.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: kDeepOrange,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Enter your Name",
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your Name';
                      }
                      return null;
                      },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Enter your Discussion Title",
                      prefixIcon: Icon(Icons.title),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your Discussion Title';
                      }
                      return null;
                      },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Enter your Discussion Description",
                      prefixIcon: Icon(Icons.description_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your Discussion Description';
                      }
                      return null;
                      },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            dbRef
                                //.doc(uid)
                                //.collection("Title")
                                .add({
                              "uid": uid,
                              "name": nameController.text,
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "timestamp": DateTime.now(),
                              "likes": 0,
                            }).then((_) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Succesfully Submitted Your Discussion!",
                                      style: TextStyle(fontFamily: 'Lato'),
                                    ),
                                    content: Text(
                                      "If you would like to add any additional discussions, press No",
                                      style: TextStyle(fontFamily: 'Lato.Thin'),
                                    ),
                                    actions: <Widget> [
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => HomePageScreen()));
                                        },
                                      ),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              titleController.clear();
                              nameController.clear();
                              descriptionController.clear();
                            }).catchError((error) => print(error));
                          }
                        },
                        child: Text('Submit'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kDeepOrangeLight),
                        )
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Return To Homepage'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
