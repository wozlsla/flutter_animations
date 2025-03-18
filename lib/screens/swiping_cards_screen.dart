import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen> {
  double posX = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      posX += details.delta.dx; // delta: amount the pointer has moved
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      posX = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Swiping Cards")),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Transform.translate(
                offset: Offset(posX, 0),
                child: Material(
                  elevation: 10,
                  color: Colors.red.shade400,
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.width * 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
