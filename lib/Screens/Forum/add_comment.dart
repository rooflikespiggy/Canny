import 'package:Canny/Services/Forum/comment_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Models/comment.dart';

import 'forum_detail_screen.dart';

class AddComment extends StatefulWidget {
  static final String id = 'add_comment';
  final String inputId;

  AddComment({this.inputId});

  @override
  _AddCommentState createState() => _AddCommentState(this.inputId);
}

class _AddCommentState extends State<AddComment> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final String inputId;

  _AddCommentState(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  Text(
                    'Answer the Question \n or Provide Feedback!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23.0,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _showTextFormFields(nameController,
                    "Enter your Name",
                    Icon(Icons.person),
                  ),
                  SizedBox(height: 15),
                  _showTextFormFields(descriptionController,
                    "Enter your Comment Description",
                    Icon(Icons.description_outlined),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              final Comment comment = Comment(uid: uid,
                                  did: inputId,
                                  name: nameController.text,
                                  description: descriptionController.text);
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context).unfocus();
                                CommentDatabaseService(inputId)
                                    .addComment(comment).then((_) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: kLightBlue,
                                        title: Text(
                                          "Comment successfully added.",
                                          style: TextStyle(fontFamily: 'Lato'),
                                        ),
                                        content: Text(
                                          "Would you like to add another comment?",
                                          style: TextStyle(fontFamily: 'Lato.Thin'),
                                        ),
                                        actions: <Widget> [
                                          SizedBox(
                                            width: 130,
                                            child: TextButton(
                                              child: Text("Back to discussion",
                                                style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor: kDarkBlue,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => ForumDetailScreen(inputId: inputId)));
                                            },
                                          ),),
                                          SizedBox(
                                            width: 150,
                                            child: TextButton(
                                              child: Text("Add another comment",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: kDarkBlue,
                                              ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                              nameController.clear();
                              descriptionController.clear();
                            },
                            child: Text('Submit'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(kDarkBlue),
                            )
                        ),
                        ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(kPalePurple),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Hero(
                    tag: 'picture',
                    child: Container(
                      height: 210.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'styles/images/Picture3.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: text,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
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
            return label;
          }
          return null;
        },
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