import 'package:flutter/material.dart';
import 'dart:math';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: BouncingBall(),
//       ),
//     );
//   }
// }

class Vector {
  double x, y;

  Vector(this.x, this.y);

  void add(Vector v) {
    x += v.x;
    y += v.y;
  }

  void mult(double n) {
    x *= n;
    y *= n;
  }

  double mag() {
    return sqrt(x * x + y * y);
  }

  void normalize() {
    double m = mag();
    if (m != 0) {
      mult(1 / m);
    }
  }

  void setMag(double len) {
    normalize();
    mult(len);
  }
}

class BouncingBall extends StatefulWidget {
  @override
  _BouncingBallState createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Vector position;
  late Vector velocity;
  late Vector acceleration;
  double ballRadius = 20.0;

  @override
  void initState() {
    super.initState();
    position = Vector(100, 100);
    velocity = Vector(2, 3.3);
    acceleration = Vector(0, 0);
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 16))
      ..addListener(() {
        update();
        setState(() {});
      })
      ..repeat();
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    checkEdges();
  }

  void checkEdges() {
    if (position.x > MediaQuery.of(context).size.width - ballRadius || position.x < ballRadius) {
      velocity.x *= -1;
    }
    if (position.y > MediaQuery.of(context).size.height - ballRadius || position.y < ballRadius) {
      velocity.y *= -1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BallPainter(position, ballRadius),
      child: Container(),
    );
  }
}

class BallPainter extends CustomPainter {
  final Vector position;
  final double ballRadius;

  BallPainter(this.position, this.ballRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(position.x, position.y), ballRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
