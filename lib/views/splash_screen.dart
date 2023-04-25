import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.onCompleted,
    super.key,
  });

  final VoidCallback onCompleted;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.8,
        curve: Curves.easeOut,
      ),
    );

    _rotateAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted.call();
        }
      },
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final rotation = 2 * pi * (_rotateAnimation.value);
            return Material(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(rotation)
                  ..scale(
                    _scaleAnimation.value,
                  ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
