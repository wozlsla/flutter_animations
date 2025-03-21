import 'package:animations/screens/apple_watch_screen.dart';
import 'package:animations/screens/explicit_animations_screen.dart';
import 'package:animations/screens/implicit_animations_screen.dart';
import 'package:animations/screens/music_player_screen.dart';
import 'package:animations/screens/swiping_cards_screen.dart';
import 'package:animations/screens/wallet_screen.dart';
import 'package:animations/tasks/explicit_task.dart';
import 'package:animations/tasks/flash_cards.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Animations")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // _goToPage(context, ImplicitTask());
                // _goToPage(context, ExplicitTask());
                // _goToPage(context, Pomodoro());
                _goToPage(context, FlashCards());
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
            ElevatedButton(
              onPressed: () {
                _goToPage(context, SwipingCardsScreen());
              },
              child: Text("Swiping Cards"),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style:
                  isDark
                      ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                      )
                      : null,
              onPressed: () {
                _goToPage(context, MusicPlayerScreen());
              },
              child: Text("Music Player"),
            ),
            SizedBox(height: 4.0),
            ElevatedButton(
              style:
                  isDark
                      ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                      )
                      : null,
              onPressed: () {
                _goToPage(context, WalletScreen());
              },
              child: Text("Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}
