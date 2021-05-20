import 'package:flutter/material.dart';
import 'function_screen.dart';

void main() {
  runApp(Canny());
}

class Canny extends StatelessWidget {
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