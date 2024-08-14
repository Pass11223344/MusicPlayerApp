import 'package:flutter/material.dart';

class loadingAnimation extends StatefulWidget {
  @override
  // TODO: implement createState
  State<loadingAnimation> createState() => _loadingAnimationState();
}

class _loadingAnimationState extends State<loadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _frameAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _frameAnimation = IntTween(
      begin: 0,
      end: 5, // 假设有5帧动画
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: _frameAnimation,
      builder: (context, child) {
        return Container();
      },
    );
  }
}
