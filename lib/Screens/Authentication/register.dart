import 'package:Canny/Services/Users/auth.dart';
import 'package:Canny/Shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:Canny/Shared/colors.dart';

class Register extends StatefulWidget {

  final Function toggleSignInStatus;
  Register({ this.toggleSignInStatus });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  // text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  bool loading = false;
  bool obscurePwd = true;
  bool obscurePwd2 = true;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Stack(
        children: [
        Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background.png"),
            fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 95.0),
                  Container(
                    width: 140.0,
                    height: 140.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('styles/images/logo-7.png'),
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
                        color: kDarkBlue,
                      )
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "You took the first step to track your expenses, hassle free! Let's get started by registering.",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Lato',
                      color: Colors.blueGrey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        TextFormField(
                          controller: emailController,
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
                            setState(() {
                              error = '';
                              email = val;
                            });
                          },
                        ),
                        SizedBox(height: 18.0),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              size: 20.0,
                            ),
                            prefixIconConstraints: BoxConstraints.tightFor(
                                width: 40, height: 30),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePwd
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePwd = !obscurePwd;
                                });
                              },
                            ),
                          ),
                          validator: (val) =>
                          val.length < 8
                              ? 'Enter a password 8+ chars long'
                              : null,
                          obscureText: obscurePwd,
                          onChanged: (val) {
                            setState(() {
                              error = '';
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 18.0),
                        TextFormField(
                          controller: rePasswordController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              size: 20.0,
                            ),
                            prefixIconConstraints: BoxConstraints.tightFor(
                                width: 40, height: 30),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePwd2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePwd2 = !obscurePwd2;
                                });
                              },
                            ),
                          ),
                          validator: (val) =>
                          val != password
                              ? 'Wrong Password, please try again.'
                              : null,
                          obscureText: obscurePwd2,
                          onChanged: (val) {
                            error = '';
                            setState(() => confirmPassword = val);
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
                        backgroundColor: kDarkBlue, // background
                      ),
                      label: Text(
                        "Register a new account with Canny",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lato",
                        ),
                      ),
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          await Future.delayed(Duration(seconds: 4));
                          print(result);
                          if(result == 'email-in-use') {
                            setState(() {
                              error = 'An account already exists for that email';
                              loading = false;
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "    Already have an account?",
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
        )
        ],
    );
  }
}

