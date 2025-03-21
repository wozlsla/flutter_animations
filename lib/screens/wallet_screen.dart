import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isExpanded = false;

  void _onExpanded() {
    setState(() {
      _isExpanded = true;
    });
  }

  void _onShrink() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onVerticalDragEnd: (_) => _onShrink(),
          onTap: _onExpanded,
          child: Column(
            children: [
                  CreditCard(
                        bgColor: Color(0xff4a4e69),
                        isExpanded: _isExpanded,
                      )
                      .animate(target: _isExpanded ? 0 : 1, delay: 1.5.seconds)
                      .flipV(end: 0.1),
                  CreditCard(
                        bgColor: Color(0xff008080),
                        isExpanded: _isExpanded,
                      )
                      .animate(target: _isExpanded ? 0 : 1, delay: 1.5.seconds)
                      .flipV(end: 0.1)
                      .slideY(end: -0.8),
                  CreditCard(
                        bgColor: Color(0xff2a6f97),
                        isExpanded: _isExpanded,
                      )
                      .animate(target: _isExpanded ? 0 : 1, delay: 1.5.seconds)
                      .flipV(end: 0.1)
                      .slideY(end: -0.8 * 2),
                ]
                .animate(interval: 500.ms)
                .fade(begin: 0)
                .slideX(begin: -1, end: 0),
          ),
        ),
      ),
    );
  }
}

void _onTap() {}

class CreditCard extends StatelessWidget {
  final Color bgColor;
  final bool isExpanded;

  const CreditCard({
    super.key,
    required this.bgColor,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isExpanded, // true: ignore
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bgColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Credit Cards",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "**** **** **80",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
