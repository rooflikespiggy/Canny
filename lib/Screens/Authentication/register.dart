import 'package:Canny/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {

  final Function toggleSignInStatus;
  Register({ this.toggleSignInStatus });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[50],
          elevation: 0.0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 140.0,
                    height: 140.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('styles/images/logo-2.png'),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                  Text(
                      'Welcome to Canny!',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      )
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "You took the first step to track your expenses, hassle free! Let's get started by registering.",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Lato',
                      color: Colors.blueGrey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              size: 20.0,
                            ),
                            prefixIconConstraints: BoxConstraints.tightFor(
                                width: 40, height: 30),
                          ),
                          validator: (val) => !EmailValidator.validate(val, true)
                              ? 'Not a valid email.'
                              : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 18.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              size: 20.0,
                            ),
                            prefixIconConstraints: BoxConstraints.tightFor(
                                width: 40, height: 30),
                          ),
                          validator: (val) =>
                          val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 18.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              size: 20.0,
                            ),
                            prefixIconConstraints: BoxConstraints.tightFor(
                                width: 40, height: 30),
                          ),
                          validator: (val) =>
                          val != password
                              ? 'Wrong Password, please try again.'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => confirmPassword = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue[700], // background
                      ),
                      label: Text(
                        "Register a new account with Canny",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if(result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              //i think register dont need error message, tmr try again!
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleSignInStatus();
                        },
                        child: Text(
                          " Sign In Here",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }
}

