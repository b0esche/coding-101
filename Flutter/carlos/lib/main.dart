import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedImageSlider(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedImageSlider extends StatefulWidget {
  const AnimatedImageSlider({super.key});

  @override
  AnimatedImageSliderState createState() => AnimatedImageSliderState();
}

class AnimatedImageSliderState extends State<AnimatedImageSlider> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Timer _timer;
  int _currentIndex = 0;
  bool _isAnimating = false;

  final List<String> images = [
    'assets/images/c2.jpeg',
    'assets/images/c1.jpeg',
  ];

  @override
  void initState() {
    _audioPlayer.setSource(AssetSource('sounds/fart-5-228245.mp3'));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_isAnimating) return;
    _isAnimating = true;
    _currentIndex = 0;
    _pageController.jumpToPage(0);

    playTapSound();

    _timer = Timer.periodic(Duration(milliseconds: 350), (timer) {
      _currentIndex++;
      if (_currentIndex >= images.length) {
        _timer.cancel();
        _isAnimating = false;
        return;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 450),
        curve: Curves.linear,
      );
    });
  }

  void playTapSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zieh an meinem Finger"),
        backgroundColor: Colors.amber,
      ),
      body: GestureDetector(
        onTap: _startAnimation,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.asset(images[index], fit: BoxFit.cover);
              },
            ),
          ],
        ),
      ),
    );
  }
}
