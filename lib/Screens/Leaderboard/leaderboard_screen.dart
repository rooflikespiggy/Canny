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
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text('Leaderboard'),
      ),
    );
  }
}
