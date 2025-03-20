import 'dart:ui';

import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(minutes: 1),
  )..repeat(reverse: true); // 정방향

  String _timeFormatter(double value) {
    // value(0.0~1.0) -> 1m(60,000ms)
    final duration = Duration(milliseconds: (value * 60000).toInt());
    final timeString =
        "${duration.inMinutes.toString().padLeft(2, "0")}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}";
    return timeString;
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/covers/${widget.index}.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.black.withValues(alpha: 0.65)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.0),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              SizedBox(height: 50.0),
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: "${widget.index}",
                  child: Container(
                    width: 350.0,
                    height: 350.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(0, 8),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/covers/${widget.index}.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              AnimatedBuilder(
                animation: _progressController,
                builder:
                    (context, child) => Column(
                      children: [
                        CustomPaint(
                          size: Size(size.width - 80, 7),
                          painter: ProgressBar(
                            progressValue: _progressController.value,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Text(
                                _timeFormatter(_progressController.value),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Text(
                                _timeFormatter(1 - _progressController.value),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    // track
    final trackPaint =
        Paint()
          ..color = Colors.grey.shade500.withValues(alpha: 0.4)
          ..style = PaintingStyle.fill;
    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(10),
    );
    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;
    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      Radius.circular(10),
    );
    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 7.5, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
