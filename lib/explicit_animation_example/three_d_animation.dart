import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CubeAnimation extends StatefulWidget {
  const CubeAnimation({super.key});

  @override
  State<CubeAnimation> createState() => _CubeAnimationState();
}

const widthAndHeight = 100.00;

class _CubeAnimationState extends State<CubeAnimation>
    with TickerProviderStateMixin {
  late AnimationController controllerX;
  late AnimationController controllerY;
  late AnimationController controllerZ;
  late Tween<double> _animation;
  @override
  void initState() {
    controllerX =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    controllerY =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    controllerZ =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    _animation = Tween<double>(
      begin: 0,
      end: pi * 2,
    );
    super.initState();
  }

  @override
  void dispose() {
    controllerX.dispose();
    controllerY.dispose();
    controllerZ.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controllerX
      ..reset()
      ..repeat();

    controllerY
      ..reset()
      ..repeat();

    controllerZ
      ..reset()
      ..repeat();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: widthAndHeight,
            width: double.infinity,
          ),
          AnimatedBuilder(
            animation:
                Listenable.merge([controllerX, controllerY, controllerZ]),
            builder: (BuildContext context, Widget? child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_animation.evaluate(controllerX))
                  ..rotateY(_animation.evaluate(controllerY))
                  ..rotateZ(_animation.evaluate(controllerZ)),
                child: Stack(
                  children: [
                    // Back
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(Vector3(0, 0, -widthAndHeight)),
                      child: Container(
                        height: widthAndHeight,
                        width: widthAndHeight,
                        color: Colors.purple,
                      ),
                    ),
                    // left side
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()..rotateY(pi / 2.0),
                      child: Container(
                        color: Colors.red,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                    // right side
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()..rotateY(-pi / 2.0),
                      child: Container(
                        height: widthAndHeight,
                        width: widthAndHeight,
                        color: Colors.blue,
                      ),
                    ),
                    // front
                    Container(
                      height: widthAndHeight,
                      width: widthAndHeight,
                      color: Colors.green,
                    ),

                    // top side

                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()..rotateX(-pi / 2.0),
                      child: Container(
                        color: Colors.orange,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),

                    // bottom side

                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..rotateX(pi / 2.0),
                      child: Container(
                        color: Colors.brown,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
