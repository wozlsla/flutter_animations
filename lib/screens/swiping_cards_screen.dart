import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
    lowerBound: size.width * -1,
    upperBound: size.width,
    value: 0.0,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _animationController.value +=
        details.delta.dx; // delta: amount the pointer has moved
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animationController.animateTo(0, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Swiping Cards")),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_animationController.value, 0),
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
          );
        },
      ),
    );
  }
}
