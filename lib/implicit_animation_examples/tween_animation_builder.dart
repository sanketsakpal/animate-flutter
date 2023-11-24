import 'package:flutter/material.dart';
import 'dart:math' as math;

class TweenAnimationBuilderExample extends StatefulWidget {
  const TweenAnimationBuilderExample({super.key});

  @override
  State<TweenAnimationBuilderExample> createState() =>
      _TweenAnimationBuilderExampleState();
}

class _TweenAnimationBuilderExampleState
    extends State<TweenAnimationBuilderExample> {
  var _color = getRandomColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ClipPath(
        clipper: CircleClipper(),
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: ColorTween(begin: getRandomColor(), end: _color),
          onEnd: () {
            setState(() {
              _color = getRandomColor();
            });
          },
          child: Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
          ),
          builder: (BuildContext context, dynamic value, Widget? child) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                value!,
                BlendMode.srcATop,
              ),
              child: child,
            );
          },
        ),
      ),
    ));
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Color getRandomColor() => Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));
