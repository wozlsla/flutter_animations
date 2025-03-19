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

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx; // delta: amount the pointer has moved
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo((dropZone) * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

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
          final scale = _scale.transform(_position.value.abs() / size.width);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // back
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: Card(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              // front
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle * pi / 180, // radian
                      child: Card(index: _index),
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

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset("assets/covers/$index.jpg", fit: BoxFit.cover),
      ),
    );
  }
}
