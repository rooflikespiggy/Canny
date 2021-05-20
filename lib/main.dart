import 'package:Canny/Models/own_user.dart';
import 'package:Canny/Screens/Wrapper.dart';
import 'package:Canny/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'function_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

/*
void main() {
  runApp(Canny());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          initialRoute: FunctionScreen.id,
          routes: {
           FunctionScreen.id: (content) => FunctionScreen(),
         }
      );
  }
}
*/
