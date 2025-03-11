import 'dart:async';

import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final _duration = Duration(seconds: 1);
  bool _isLeft = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        _isLeft = !_isLeft;
      });
    });

    _animationLoop();
  }

  void _animationLoop() {
    Timer.periodic(_duration, (timer) {
      setState(() {
        _isLeft = !_isLeft;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _isLeft ? Colors.black : Colors.white,
      body: Center(
        child: Stack(
          children: [
            Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(_isLeft ? 100 : 0),
                shape: _isLeft ? BoxShape.rectangle : BoxShape.circle,
                color: Colors.red.shade400,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween(
                begin: _isLeft ? 0 : (size.width * 0.7 - size.width * 0.05),
                end: _isLeft ? (size.width * 0.7 - size.width * 0.05) : 0,
              ),
              duration: _duration,
              builder: (context, isLeft, child) {
                return AnimatedPositioned(
                  duration: _duration,
                  left: _isLeft ? (size.width * 0.7 - size.width * 0.05) : 0,
                  top: 0,
                  child: Container(
                    width: size.width * 0.05,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: _isLeft ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
