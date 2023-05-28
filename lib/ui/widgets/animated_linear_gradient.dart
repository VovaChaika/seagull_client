import 'package:flutter/material.dart';

class AnimatedLinearGradient extends StatefulWidget {
  final Widget child;

  const AnimatedLinearGradient({Key? key, required this.child})
      : super(key: key);

  @override
  State<AnimatedLinearGradient> createState() => _AnimatedLinearGradientState();
}

class _AnimatedLinearGradientState extends State<AnimatedLinearGradient>
    with SingleTickerProviderStateMixin {
  // SingleTickerProvider
  late final AnimationController animationController;

  late final Animation<double> rotationAnimation;
  late final Animation<Color?> topColorAnimation;
  late final Animation<Color?> bottomColorAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(minutes: 1), vsync: this);

    rotationAnimation = // a circle
        Tween<double>(begin: 0, end: 6.283).animate(animationController);

    topColorAnimation =
        ColorTween(begin: Colors.cyanAccent, end: Colors.tealAccent)
            .animate(animationController); // color

    bottomColorAnimation =
        ColorTween(begin: Colors.blueAccent, end: Colors.cyanAccent)
            .animate(animationController); // color

    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.reverse();
      }
      if (animationController.isDismissed) {
        animationController.forward();
      }
      setState(() {});
    });

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          transform: GradientRotation(rotationAnimation.value), // rotates
          // color
          colors: [topColorAnimation.value!, bottomColorAnimation.value!],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: widget.child,
    );
  }
}
