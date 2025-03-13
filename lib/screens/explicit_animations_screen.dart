import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this, // late
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  )..addListener(() {
    // setState(() {
    //   _range = _animationController.value;
    // });
    _range.value = _animationController.value;
  });

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20.0),
    ),
    end: BoxDecoration(
      color: Colors.red.shade400,
      borderRadius: BorderRadius.circular(120.0),
    ),
  ).animate(_curved);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curved);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
  ).animate(_curved);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: Offset(0.0, -0.2),
  ).animate(_curved);

  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // double _range = 0.0; // setState
  final ValueNotifier<double> _range = ValueNotifier(
    0.0,
  ); // without build method

  void _onChanged(double value) {
    // setState(() {
    //   _range = value;
    // });
    _range.value = 0;
    _animationController.value = value; // set value(override)
    // _animationController.animateTo(value); // set animation
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(width: 400, height: 400),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text("Play")),
                ElevatedButton(onPressed: _pause, child: const Text("Pause")),
                ElevatedButton(onPressed: _rewind, child: const Text("Rewind")),
              ],
            ),
            SizedBox(height: 25.0),
            // Slider(value: _range.value, onChanged: _onChanged),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(value: value, onChanged: _onChanged);
              },
            ),
          ],
        ),
      ),
    );
  }
}
