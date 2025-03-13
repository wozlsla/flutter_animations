import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Implict Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              curve: Curves.elasticOut,
              duration: const Duration(seconds: 2),
              width: size.width * 0.8,
              height: size.width * 0.8,
              transform: Matrix4.rotationZ(_visible ? 1 : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            // TweenAnimationBuilder(
            //   tween: ColorTween(
            //     begin: Colors.amber.shade400,
            //     end: Colors.blue.shade400,
            //   ),
            //   curve: Curves.bounceOut,
            //   duration: Duration(seconds: 5),
            //   builder: (context, value, child) {
            //     return Opacity(
            //       opacity: _visible ? 1.0 : 0.6, // _trigger
            //       child: Image.network(
            //         "https://kili.aspix.it/Dash.png",
            //         color: value,
            //         colorBlendMode: BlendMode.colorBurn,
            //       ),
            //     );
            //   },
            // ),
            SizedBox(height: 50),
            ElevatedButton(onPressed: _trigger, child: Text("Start")),
          ],
        ),
      ),
    );
  }
}
