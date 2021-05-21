import 'package:Canny/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


class SignIn extends StatefulWidget {

  final Function toggleSignInStatus;

  SignIn ({ this.toggleSignInStatus });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

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
                    "Good to see you again! Let's get you signed in.",
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
                          validator: (val) =>
                          !EmailValidator.validate(val, true)
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
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 13.0),
                  ),
                  SizedBox(height: 12.0),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlue[700], // background
                    ),
                    label: Text(
                      'Sign In with Email and Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lato",
                      ),
                    ),
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.signInWithEmailAndPassword(
                        email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Sign in failed, Email or Password incorrect';
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
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleSignInStatus();
                        },
                        child: Text(
                          "Create account",
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
