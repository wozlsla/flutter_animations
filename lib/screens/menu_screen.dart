import 'package:animations/screens/apple_watch_screen.dart';
import 'package:animations/screens/explicit_animations_screen.dart';
import 'package:animations/screens/implicit_animations_screen.dart';
import 'package:animations/tasks/explicit_task.dart';
import 'package:animations/tasks/implicit_task.dart';
import 'package:animations/tasks/pomodoro.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Animations")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // _goToPage(context, ImplicitTask());
                // _goToPage(context, ExplicitTask());
                _goToPage(context, Pomodoro());
              },
              child: Text("Tasks"),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, ImplicitAnimationsScreen());
              },
              child: Text("Implicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, ExplicitAnimationsScreen());
              },
              child: Text("Explicit Animations"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, AppleWatchScreen());
              },
              child: Text("Apple Watch"),
            ),
          ],
        ),
      ),
    );
  }
}
