import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class PolyGonExample extends StatefulWidget {
  const PolyGonExample({super.key});

  @override
  State<PolyGonExample> createState() => _PolyGonExampleState();
}

class _PolyGonExampleState extends State<PolyGonExample>
    with TickerProviderStateMixin {
  late AnimationController sidesController;
  late Animation<int> sidesAnimation;

  late AnimationController radiusController;
  late Animation<double> radiusAnimation;

  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    sidesAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(sidesController);

    radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    radiusAnimation = Tween(
      begin: 20.0,
      end: 400.0,
    )
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(radiusController);

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    rotationAnimation = Tween(
      begin: 0.0,
      end: 2 * pi,
    )
        .chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        )
        .animate(rotationController);
  }

  @override
  void dispose() {
    sidesController.dispose();
    radiusController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sidesController.repeat(reverse: true);
    radiusController.repeat(reverse: true);
    rotationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom painter does not have size by default
      // child is widget that take a space
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [sidesController, radiusController, rotationController]),
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(rotationAnimation.value)
                ..rotateY(rotationAnimation.value)
                ..rotateZ(rotationAnimation.value),
              child: CustomPaint(
                painter: PolygonPainter(sides: sidesAnimation.value),
                child: SizedBox(
                  height: radiusAnimation.value,
                  width: radiusAnimation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;

  PolygonPainter({super.repaint, required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    // paint is like pen or brush to draw on canvas
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);

    final angle = 2 * pi / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

    // in order to get x axis

    // x = center.x + radius * cos(angle)
    // y = center.y + radius * sin(angle)

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (var angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) => oldDelegate.sides != sides;

  @override
  bool shouldRebuildSemantics(PolygonPainter oldDelegate) => false;
}
