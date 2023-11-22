import 'package:flutter/material.dart';
import 'dart:math' show pi;

class ChainedAnimation extends StatefulWidget {
  const ChainedAnimation({super.key});

  @override
  State<ChainedAnimation> createState() => _ChainedAnimationState();
}

enum CircleSide { right, left }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();

    late Offset offset;
    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
      default:
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(
          size.width / 2,
          size.height / 2,
        ),
        clockwise: clockWise);
    path.close();
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) {
    return Future.delayed(duration, this);
  }
}

class _ChainedAnimationState extends State<ChainedAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  late AnimationController flipController;
  late Animation<double> flipAnimation;
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    flipController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    flipAnimation = Tween<double>(begin: 0, end: pi).animate(
        CurvedAnimation(parent: flipController, curve: Curves.bounceOut));

    animation = Tween<double>(begin: 0, end: -(pi / 2)).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));

    super.initState();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flipAnimation = Tween<double>(
          begin: flipAnimation.value,
          end: flipAnimation.value + pi,
        ).animate(
            CurvedAnimation(parent: flipController, curve: Curves.bounceOut));
        // reset the flip controller and start animation
        flipController
          ..reset()
          ..forward();
      }
    });

    flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animation = Tween<double>(
            begin: animation.value,
            end: animation.value + -(pi / 2.0),
          ).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.bounceOut,
            ),
          );

          animationController
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController
      ..reset()
      ..forward.delayed(
        const Duration(seconds: 1),
      );
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(animation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: flipController,
                    child: child,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: flipAnimation,
                    child: child,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({super.reclip, required this.side});

  @override
  getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
