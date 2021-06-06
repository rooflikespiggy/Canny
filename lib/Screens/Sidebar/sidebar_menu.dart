import 'package:Canny/Screens/Sidebar/Quick%20Input/customise_quickinput.dart';
import 'package:Canny/Services/Users/auth.dart';
import 'package:Canny/Shared/custom_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:Canny/Screens/wrapper.dart';
import 'package:Canny/Screens/Sidebar/View Categories/category_screen.dart';

class SideBarMenu extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kLightBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kDarkBlue,
                image: DecorationImage(
                  image: AssetImage('styles/images/logo-8.png'),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Container(
                  child: Text(email,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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
                  fontSize: 16,
                )
              ),
              onTap: () => {
                Navigator.push(context,
                    NoAnimationMaterialPageRoute(builder: (context) => CustomiseQI()))
              },
            ),
            Divider(thickness: 1.0),
            ListTile(
              leading: Icon(Icons.category),
              trailing: Icon(Icons.arrow_right),
              title: Text(
                'View Categories',
                  style: TextStyle(fontFamily: 'Lato',
                    fontSize: 16,
                  )
              ),
              onTap: () => {
                Navigator.push(context,
                    NoAnimationMaterialPageRoute(builder: (context) => CategoryScreen()))
              },
            ),
            Divider(thickness: 1.0),
            // SizedBox(height: 400.0),
            // SizedBox(height: 400.0),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                  style: TextStyle(fontFamily: 'Lato',
                    fontSize: 16,
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
