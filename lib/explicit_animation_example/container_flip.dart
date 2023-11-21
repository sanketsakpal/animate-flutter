import 'package:flutter/material.dart';
import 'dart:math' show pi;

class ContainerFlip extends StatefulWidget {
  const ContainerFlip({super.key});

  @override
  State<ContainerFlip> createState() => _ContainerFlipState();
}

class _ContainerFlipState extends State<ContainerFlip>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(animation.value),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blueAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
