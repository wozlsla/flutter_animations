import 'dart:math';

import 'package:flutter/material.dart';

Map<String, String> dict = {
  "01": "January",
  "02": "February",
  "03": "March",
  "04": "April",
  "05": "May",
  "06": "June",
  "07": "July",
  "08": "August",
  "09": "September",
  "10": "October",
  "11": "November",
  "12": "December",
};

class FlashCards extends StatefulWidget {
  const FlashCards({super.key});

  @override
  State<FlashCards> createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> with TickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final dropZone = size.width + 100;

  final baseColor = Color(0xFF209BC4);
  final leftColor = Color(0xFFE9435A);
  final rightColor = Color(0xff0CA37F);

  late Color currentColor;

  int _index = 0;
  String message = "";

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    lowerBound: dropZone * -1,
    upperBound: dropZone,
    value: 0.0,
  );

  late final Tween<double> _rotate = Tween(begin: -15, end: 15);
  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
    if (_position.value < 0) {
      setState(() {
        currentColor = leftColor;
        message = "save";
      });
    } else {
      setState(() {
        currentColor = rightColor;
        message = "pass";
      });
    }
  }

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  late Animation<double> _progressAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(_curve);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _progressController,
    curve: Curves.easeInOut,
  );

  void _animateProgress() {
    final newBegin = _progressAnimation.value;
    final newEnd = _index / (dict.length - 1);
    setState(() {
      _progressAnimation = Tween(begin: newBegin, end: newEnd).animate(_curve);
    });
    _progressController.forward(from: 0);
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == dict.length - 1 ? 0 : _index + 1;
      _animateProgress();
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo((dropZone) * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
    setState(() {
      currentColor = baseColor;
      message = "";
    });
  }

  @override
  void initState() {
    super.initState();
    currentColor = baseColor; // init
  }

  @override
  void dispose() {
    _position.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Flash Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle =
              _rotate.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 30,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: FlashCard(text: ""),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: FlipCard(index: _index),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        color: currentColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder:
                (context, child) => CustomPaint(
                  painter: ProgressBar(progressValue: _progressAnimation.value),
                  size: Size(size.width - 80, 20),
                ),
          ),
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final int index;

  const FlipCard({super.key, required this.index});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;

  late final AnimationController _flipController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  late final Animation<double> _flipAnimation = Tween<double>(
    begin: 0,
    end: pi,
  ).animate(_flipController);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }

    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = dict.entries.elementAt(widget.index);

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          double angle = _flipAnimation.value;
          bool isFrontVisible = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(angle),
            child:
                isFrontVisible
                    ? FlashCard(text: entry.key) // front
                    : FlashCard(text: entry.value, isFlipped: true), // back
          );
        },
      ),
    );
  }
}

class FlashCard extends StatelessWidget {
  final String text;
  final bool isFlipped;

  const FlashCard({super.key, required this.text, this.isFlipped = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Transform(
      alignment: Alignment.center,
      transform: isFlipped ? Matrix4.rotationY(pi) : Matrix4.identity(),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.5,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
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

    final barPaint =
        Paint()
          ..color = Colors.grey.shade400
          ..style = PaintingStyle.fill;

    final barRect = RRect.fromLTRBR(
      0, // left
      0, // top
      size.width, // right
      size.height, // bottom
      Radius.circular(10),
    );

    canvas.drawRRect(barRect, barPaint);

    final progressPaint =
        Paint()
          ..color = Colors.grey.shade800
          ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
