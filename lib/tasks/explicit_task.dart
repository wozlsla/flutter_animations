import 'package:flutter/material.dart';

class ExplicitTask extends StatelessWidget {
  const ExplicitTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // 5x5
        children: List.generate(
          5,
          (rowIdx) => Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Column: 자식의 높이에 맞춰짐 !!
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Row: 부모의 넓이
                children: List.generate(5, (cols) {
                  return Box(delay: 1);
                }),
              ),
              if (rowIdx < 4) SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final int delay;

  const Box({super.key, required this.delay});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 2),
  );

  late final Animation<Color?> _color = TweenSequence<Color?>([
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.pink, end: Colors.green),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.green, end: Colors.red),
      weight: 50,
    ),
  ]).animate(_animationController);

  late final Animation<BorderRadius?> _borderRadius = BorderRadiusTween(
    begin: BorderRadius.circular(10.0),
    end: BorderRadius.zero,
  ).animate(_animationController);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 0.8,
  ).animate(_animationController);

  late final Animation<double> _opacity = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).animate(_animationController);

  // hold values : _animationConroller (0.0 ~ 0.1)
  final ValueNotifier<double> _range = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      _range.value = _animationController.value;
    });

    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) {
        _animationController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _range, // value 변경 감지, UI(only container) rebuild
      builder: (context, value, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _color.value,
                borderRadius: _borderRadius.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
