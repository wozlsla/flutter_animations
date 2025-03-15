import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
    lowerBound: 0.005,
    upperBound: 2.0,
  );

  void _animatedValues() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, chile) {
            return CustomPaint(
              painter: AppleWatchPainter(progress: _animationController.value),
              size: Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animatedValues,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress;

  AppleWatchPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startingAngle = -0.5 * pi;

    // draw red
    final redCircleRadius = (size.width / 2) * 0.9;
    final redCirclePaint =
        Paint()
          ..color = Colors.red.shade400.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 25;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    // draw green
    final greenCircleRadius = (size.width / 2) * 0.76;
    final greenCirclePaint =
        Paint()
          ..color = Colors.green.shade400.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 25;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    // draw blue
    final blueCircleRadius = (size.width / 2) * 0.62;
    final blueCirclePaint =
        Paint()
          ..color = Colors.blue.shade400.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 25;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );
    final greenArcPaint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      progress * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );
    final blueArcPaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      progress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(AppleWatchPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
