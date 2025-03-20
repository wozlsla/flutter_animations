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

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("I DO ME")),
      body: Column(
        children: [
          SizedBox(height: 30.0),
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
                (context, child) => CustomPaint(
                  size: Size(size.width - 80, 7),
                  painter: ProgressBar(
                    progressValue: _progressController.value,
                  ),
                ),
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
