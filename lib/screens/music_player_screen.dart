import 'dart:ui';

import 'package:animations/screens/music_player_detail_screen.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage; // 현재 page 저장
    });
  }

  void _onTap(int imageIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerDetailScreen(index: imageIndex),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      // print(_pageController.page); // setState 호출 - rebuild (비효율)
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/covers/${_currentPage + 1}.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
          ),
          PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - (difference * 0.1); // sides 10% 축소

                      return GestureDetector(
                        onTap: () => _onTap(index + 1),
                        child: Hero(
                          tag: "${index + 1}",
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/covers/${index + 1}.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "I DO ME",
                    style: TextStyle(fontSize: 26.0, color: Colors.white),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "KiiiKiii",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
