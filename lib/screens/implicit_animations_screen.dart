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
    return Scaffold(
      appBar: AppBar(title: Text("Implicit Animations")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: ColorTween(
                begin: Colors.amber.shade400,
                end: Colors.blue.shade400,
              ),
              curve: Curves.bounceOut,
              duration: Duration(seconds: 5),
              builder: (context, value, child) {
                return Opacity(
                  opacity: _visible ? 1.0 : 0.6, // _trigger
                  child: Image.network(
                    "https://kili.aspix.it/Dash.png",
                    color: value,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            ElevatedButton(onPressed: _trigger, child: Text("Start")),
          ],
        ),
      ),
    );
  }
}
