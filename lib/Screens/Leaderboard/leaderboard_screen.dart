import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  static final String id = 'leaderboard_screen';

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LEADERBOARD",
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      drawer: SideBarMenu(),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Leaderboard'),
      ),
    );
  }
}
