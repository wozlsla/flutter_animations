import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100), //+100 for hide card
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx; // delta: amount the pointer has moved
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // print(_position.value.abs());
    // print(size.width - 100);
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo((dropZone) * -1);
      } else {
        _position.animateTo(dropZone);
      }
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Swiping Cards")),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
            (_position.value / 2 + size.width / 2) / size.width,
          );
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle * pi / 180, // radian
                      child: Material(
                        elevation: 10,
                        color: Colors.red.shade400,
                        child: SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
