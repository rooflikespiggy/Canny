import 'package:Canny/Models/own_user.dart';
import 'package:Canny/Screens/Wrapper.dart';
import 'package:Canny/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<OwnUser>.value(
      value: AuthService().userFromStream,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

