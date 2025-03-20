import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(minutes: 1),
  )..repeat(reverse: true); // 정방향

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 16),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: Offset(0.1, 0),
    end: Offset(-0.6, 0),
  ).animate(_marqueeController); // fraction

  late final AnimationController _playController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  );

  final Curve _menuCurve = Curves.easeInOut;

  late final Animation<double> _screenScale = Tween(
    begin: 1.0,
    end: 0.7,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.0, 0.3, curve: _menuCurve),
    ),
  );

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: Offset(0.5, 0),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.2, 0.4, curve: _menuCurve),
    ),
  );

  late final Animation<double> _closeButtonOpacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.3, 0.5, curve: _menuCurve),
    ),
  );

  late final Animation<Offset> _profileSlide = Tween<Offset>(
    begin: Offset(-1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.4, 0.7, curve: _menuCurve),
    ),
  );

  String _timeFormatter(double value) {
    // value(0.0~1.0) -> 1m(60,000ms)
    final duration = Duration(milliseconds: (value * 60000).toInt());
    final timeString =
        "${duration.inMinutes.toString().padLeft(2, "0")}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}";
    return timeString;
  }

  void _onPlayTap() {
    if (_playController.isCompleted) {
      _playController.reverse();
    } else {
      _playController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier(0.0);

  late final size = MediaQuery.of(context).size;
  late final barWidth = size.width - 80;
  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;
    _volume.value = _volume.value.clamp(0.0, barWidth);
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {"icon": Icons.person, "text": "Profile"},
    {"icon": Icons.notifications, "text": "Notifications"},
    {"icon": Icons.settings, "text": "Settings"},
  ];

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Scaffold
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: FadeTransition(
              opacity: _closeButtonOpacity,
              child: IconButton(
                color: Colors.white,
                onPressed: _closeMenu,
                icon: Icon(Icons.close),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                for (var menu in _menus) ...[
                  SlideTransition(
                    position: _profileSlide,
                    child: Row(
                      children: [
                        Icon(menu["icon"], color: Colors.grey.shade200),
                        SizedBox(width: 10.0),
                        Text(
                          menu["text"],
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0), // fill column
                ],
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10.0),
                    Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Foreground Scaffold (music player) : Clip - BackdropFilter
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: ClipRRect(
              child: Scaffold(
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/covers/${widget.index}.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.65),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 70.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            IconButton(
                              onPressed: _openMenu,
                              icon: Icon(Icons.menu),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.0),
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: "${widget.index}",
                            child: Container(
                              width: 350.0,
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
                                    "assets/covers/${widget.index}.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0),
                        AnimatedBuilder(
                          animation: _progressController,
                          builder:
                              (context, child) => Column(
                                children: [
                                  CustomPaint(
                                    size: Size(barWidth, 7),
                                    painter: ProgressBar(
                                      progressValue: _progressController.value,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _timeFormatter(
                                            _progressController.value,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          _timeFormatter(
                                            1 - _progressController.value,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "I DO ME",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SlideTransition(
                          position: _marqueeTween,
                          child: const Text(
                            "KiiiKiii - The 1st EP [UNCUT GEM] Let's laugh out loud in this world with five kids!",
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        GestureDetector(
                          onTap: _onPlayTap,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedIcon(
                                icon: AnimatedIcons.pause_play,
                                progress: _playController,
                                size: 60.0,
                              ),
                              // LottieBuilder.asset(
                              //   "assets/icons/lottie_play.json",
                              //   controller: _playController,
                              //   onLoaded: (composition) {
                              //     _playController.duration = composition.duration;
                              //   },
                              //   width: 150,
                              //   height: 150,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        GestureDetector(
                          onHorizontalDragUpdate: _onVolumeDragUpdate,
                          onHorizontalDragStart: (_) => _toggleDragging(),
                          onHorizontalDragEnd: (_) => _toggleDragging(),
                          child: AnimatedScale(
                            scale: _dragging ? 1.1 : 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.bounceOut,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: ValueListenableBuilder(
                                valueListenable: _volume,
                                builder:
                                    (context, value, child) => CustomPaint(
                                      size: Size(barWidth, 16),
                                      painter: VolumePaint(volume: value),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    // track
    final trackPaint =
        Paint()
          ..color = Colors.grey.shade500.withValues(alpha: 0.4)
          ..style = PaintingStyle.fill;
    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(10),
    );
    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;
    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      Radius.circular(10),
    );
    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 7.5, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePaint extends CustomPainter {
  final double volume;

  VolumePaint({required this.volume});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint =
        Paint()..color = Colors.grey.shade500.withValues(alpha: 0.4);
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;
    final volumeRect = Rect.fromLTWH(0, 0, volume, size.height);
    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePaint oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
