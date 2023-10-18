// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BouncingBallAnimation extends StatefulWidget {
  const BouncingBallAnimation({super.key});

  @override
  State<BouncingBallAnimation> createState() => _BouncingBallAnimationState();
}

class _BouncingBallAnimationState extends State<BouncingBallAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    super.initState();

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    //   controller.addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       controller.forward();
    //     }
    //   });

    animation.addListener(() {
      if (animation.isCompleted) {
        controller.reverse();
      } else if (animation.isDismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => CustomPaint(
              size: const Size(200, 300),
              painter: BouncingBallPainter(animationValue: animation.value),
            ),
          )
        ],
      )),
    );
  }
}

class BouncingBallPainter extends CustomPainter {
  double animationValue;
  BouncingBallPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height - size.height * animationValue),
        20,
        Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(BouncingBallPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BouncingBallPainter oldDelegate) => false;
}
