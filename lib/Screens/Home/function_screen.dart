import 'package:flutter/material.dart';

class FunctionScreen extends StatefulWidget {
  static final String id = 'function_screen';

  @override
  _FunctionScreenState createState() => _FunctionScreenState();
}

class _FunctionScreenState extends State<FunctionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('styles/images/logo-2.png'),
                height: 200.0,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            MaterialButton(
              onPressed: () {
                print("Test Quick Input");
                // Navigator.pushNamed(context, RegistrationScreen.id);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              minWidth: 200.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Quick Input',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            MaterialButton(
              onPressed: () {
                print("Test Dashboard");
                // Navigator.pushNamed(context, RegistrationScreen.id);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              elevation: 5.0,
              color: Colors.blueAccent,
              minWidth: 200.0,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width:10.0,
                  ),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/logo.png'),
                height: 200.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
