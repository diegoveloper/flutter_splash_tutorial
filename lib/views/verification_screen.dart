import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_splash_tutorial/views/splash_screen.dart';

import 'home_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  int _counter = 0;
  OverlayEntry? overlayEntry;

  void _onLoad() {
    final overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (_) {
      return Positioned.fill(
        child: SplashScreen(
          onCompleted: () {
            overlayEntry?.remove();
          },
        ),
      );
    });

    overlayState.insert(overlayEntry!);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoad();
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        // Here, we'll have some async calls
        setState(() {
          _counter = timer.tick;
        });
        if (_counter == 2) {
          // Replace the root with a new screen (home or login screen)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Loading...'),
          const SizedBox(height: 10),
          Text(
            _counter.toString(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
