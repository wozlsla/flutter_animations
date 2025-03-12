import 'dart:async';

import 'package:flutter/material.dart';

class ImplicitTask extends StatefulWidget {
  const ImplicitTask({super.key});

  @override
  State<ImplicitTask> createState() => _ImplicitTaskState();
}

class _ImplicitTaskState extends State<ImplicitTask> {
  final _duration = Duration(seconds: 1);
  bool _isLeft = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 시작 시 begin == end : animation 즉시 시작
    Future.delayed(Duration.zero, () {
      setState(() {
        _isLeft = !_isLeft;
      });
    });

    _animationLoop();
  }

  void _animationLoop() {
    _timer = Timer.periodic(_duration, (timer) {
      if (mounted) {
        setState(() {
          _isLeft = !_isLeft;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
