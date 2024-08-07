import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Random Walk')),
        body: RandomWalkWidget(),
      ),
    );
  }
}

class Walker {
  double x;
  double y;
  final List<int> directions = [1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 4];
  final Random rand = Random();

  Walker(double width, double height)
      : x = width / 2,
        y = height / 2;

  void show(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
  }

  void step() {
    int choice = directions[rand.nextInt(directions.length)];

    switch (choice) {
      case 1:
        x += 1;
        break;
      case 2:
        x -= 1;
        break;
      case 3:
        y += 1;
        break;
      case 4:
        y -= 1;
        break;
    }
  }
}

class RandomWalkWidget extends StatefulWidget {
  @override
  _RandomWalkWidgetState createState() => _RandomWalkWidgetState();
}

class _RandomWalkWidgetState extends State<RandomWalkWidget> {
  late Walker walker;
  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      walker = Walker(size.width, size.height);
      _startWalking();
    });
  }

  void _startWalking() {
    Future.doWhile(() async {
      setState(() {
        walker.step();
        points.add(Offset(walker.x, walker.y));
      });
      await Future.delayed(Duration(microseconds: 1000));
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RandomWalkPainter(points),
      child: Container(),
    );
  }
}

class RandomWalkPainter extends CustomPainter {
  final List<Offset> points;

  RandomWalkPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    for (final point in points) {
      canvas.drawPoints(PointMode.points, [point], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
