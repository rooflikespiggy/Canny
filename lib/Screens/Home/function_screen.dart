import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Quick Input/quick_input.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Services/Users/auth.dart';
import 'package:Canny/Shared/colors.dart';

class FunctionScreen extends StatefulWidget {
  static final String id = 'function_screen';

  @override
  _FunctionScreenState createState() => _FunctionScreenState();
}

class _FunctionScreenState extends State<FunctionScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 110.0),
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('styles/images/logo-2.png'),
                height: 140.0,
              ),
            ),
            MaterialButton(
              onPressed: () {
                // print("Test Quick Input");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuickInput()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              elevation: 1.0,
              color: kDeepOrangePrimary,
              minWidth: 200.0,
              height: 44.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calculate_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Quick Input',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: "Lato",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.0),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePageScreen()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              elevation: 1.0,
              color: kDeepOrangeLight,
              minWidth: 200.0,
              height: 44.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: "Lato",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 27.0),
            Hero(
              tag: 'picture',
              child: Container(
                width: 220.0,
                height: 200.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'styles/images/Function-Screen-illustration.png'),
                      fit: BoxFit.fill),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Container(
          height: 100.0,
          width: 120.0,
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: () async {
                await _auth.signOut();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              elevation: 1.0,
              label: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Lato",
                ),
              ),
              icon: Icon(Icons.exit_to_app),
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
