import 'package:Canny/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Screens/wrapper.dart';
import 'package:Canny/Screens/Sidebar/category_screen.dart';

class SideBarMenu extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kBackgroundColour,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kDeepOrangePrimary,
                image: DecorationImage(
                  image: AssetImage('styles/images/smaller-logo-3.png'),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 7.0),
                child: Container(
                  child: Text(email,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  height: 40.0,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate_outlined),
              trailing: Icon(Icons.arrow_right),
              title: Text(
                'Customise Quick Input',
                style: TextStyle(fontFamily: 'Lato',
                  fontSize: 15,
                )
              ),
              onTap: () => {Navigator.pop(context)},
            ),
            Divider(thickness: 1.0),
            ListTile(
              leading: Icon(Icons.category),
              trailing: Icon(Icons.arrow_right),
              title: Text(
                'View Categories',
                  style: TextStyle(fontFamily: 'Lato',
                    fontSize: 15,
                  )
              ),
              onTap: () => {Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()))
              },
            ),
            Divider(thickness: 1.0),
            // SizedBox(height: 400.0),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                  style: TextStyle(fontFamily: 'Lato',
                    fontSize: 15,
                  )
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
