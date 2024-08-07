import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Perlin Noise Visualization')),
        body: PerlinNoiseWidget(),
      ),
    );
  }
}


class PerlinNoise {
  final int seed;
  late List<int> permutations;

  PerlinNoise({this.seed = 0}) {
    _generatePermutations();
  }

  void _generatePermutations() {
    final List<int> tempList = List<int>.generate(256, (i) => i);
    final random = Random(seed);
    tempList.shuffle(random);
    permutations = List<int>.from(tempList)..addAll(tempList);
  }

  double _fade(double t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
  }

  double _grad(int hash, double x, double y) {
    final h = hash & 15;
    final u = h < 8 ? x : y;
    final v = h < 4 ? y : (h == 12 || h == 14 ? x : 0);
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
  }

  double _lerp(double t, double a, double b) {
    return a + t * (b - a);
  }

  double noise(double x, double y) {
    final X = x.floor() & 255;
    final Y = y.floor() & 255;

    x -= x.floor();
    y -= y.floor();

    final u = _fade(x);
    final v = _fade(y);

    final aa = permutations[X + permutations[Y]];
    final ab = permutations[X + permutations[Y + 1]];
    final ba = permutations[X + 1 + permutations[Y]];
    final bb = permutations[X + 1 + permutations[Y + 1]];

    final gradAA = _grad(aa, x, y);
    final gradBA = _grad(ba, x - 1, y);
    final gradAB = _grad(ab, x, y - 1);
    final gradBB = _grad(bb, x - 1, y - 1);

    final lerpX1 = _lerp(u, gradAA, gradBA);
    final lerpX2 = _lerp(u, gradAB, gradBB);
    return _lerp(v, lerpX1, lerpX2);
  }
}

class PerlinNoisePainter extends CustomPainter {
  final PerlinNoise perlinNoise;

  PerlinNoisePainter(this.perlinNoise);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    final cellSize = 5.0; // 작은 사각형의 크기

    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final noiseValue = perlinNoise.noise(x * 0.1, y * 0.1);
        final colorValue = ((noiseValue + 1) * 0.5 * 255).toInt();
        paint.color = Color.fromARGB(255, colorValue, colorValue, colorValue);

        canvas.drawRect(Rect.fromLTWH(x, y, cellSize, cellSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PerlinNoiseWidget extends StatefulWidget {
  @override
  _PerlinNoiseWidgetState createState() => _PerlinNoiseWidgetState();
}

class _PerlinNoiseWidgetState extends State<PerlinNoiseWidget> {
  late PerlinNoise perlinNoise;

  @override
  void initState() {
    super.initState();
    perlinNoise = PerlinNoise(seed: 0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PerlinNoisePainter(perlinNoise),
      child: Container(),
    );
  }
}

