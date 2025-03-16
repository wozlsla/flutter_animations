import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double _progress = 2.0;
  double _oldProgress = 2.0;

  static const _minutes = 60 * 1;
  int totalSeconds = 60 * 1;
  bool isRunning = false;
  Timer? _timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalSeconds = _minutes;
        _progress = 2.0;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
        _oldProgress = _progress;
        _progress = totalSeconds / _minutes * 2.0;
      });
    }
  }

  void _onStartPressed() {
    _timer = Timer.periodic(Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  void _onPausePressed() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _onResetPressed() {
    _onPausePressed();
    setState(() {
      totalSeconds = _minutes;
      _progress = 2.0;
      _oldProgress = 2.0;
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          // spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: SizedBox(
                    child: Text(
                      format(totalSeconds),
                      style: const TextStyle(
                        fontSize: 62,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween(begin: _oldProgress, end: _progress),
                  duration: Duration(seconds: 1),
                  builder: (context, double value, child) {
                    return CustomPaint(
                      painter: ProgressPainter(progress: value),
                      size: Size(300, 300),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "resetButton", // hero
                  onPressed: _onResetPressed,
                  backgroundColor: Colors.grey[800],
                  mini: true,
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "startButton",
                  onPressed: isRunning ? _onPausePressed : _onStartPressed,
                  backgroundColor: Colors.red.shade400,
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "pauseButton",
                  onPressed: _onPausePressed,
                  backgroundColor: Colors.grey[800],
                  mini: true,
                  child: Icon(Icons.stop, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startingAngle = -0.5 * pi;
    final radius = (size.width / 2) * 0.9;

    final backgroundPaint =
        Paint()
          ..color = Colors.grey.shade400.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 25;

    canvas.drawCircle(center, radius, backgroundPaint);

    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final arcPaint =
        Paint()
          ..color = Colors.red.shade400
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25;

    canvas.drawArc(arcRect, startingAngle, progress * pi, false, arcPaint);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
