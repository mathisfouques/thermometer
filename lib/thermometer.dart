import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Thermometer extends StatelessWidget {
  final ValueNotifier<double> temperature;

  const Thermometer(this.temperature, {super.key});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final maxWidth = min(200.0, MediaQuery.of(context).size.width / 2 - 20);

    final maxContainedMercuryHeight = maxHeight - 60;
    final maxContainedMercuryWidth = maxWidth - 20;

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Center(
        child: Container(
          height: maxContainedMercuryHeight,
          width: maxContainedMercuryWidth,
          decoration: ShapeDecoration(
            color: Colors.blue.shade100,
            shape: const StadiumBorder(),
          ),
          clipBehavior: Clip.antiAlias,
          child: ValueListenableBuilder(
            valueListenable: temperature,
            builder: (context, value, _) {
              return AnimatedMercuryPaintWidget(
                temperature: value,
              );
            },
          ),
        ),
      ),
    );
  }
}

class AnimatedMercuryPaintWidget extends StatefulWidget {
  final double temperature;

  const AnimatedMercuryPaintWidget({
    super.key,
    required this.temperature,
  });

  @override
  State<AnimatedMercuryPaintWidget> createState() =>
      _AnimatedMercuryPaintWidgetState();
}

class _AnimatedMercuryPaintWidgetState extends State<AnimatedMercuryPaintWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          painter: MercuryPainter(
            animation: _animation.value,
            temperatureReduced: widget.temperature,
          ),
        );
      },
    );
  }
}

class MercuryPainter extends CustomPainter {
  final double temperatureReduced;
  final double animation;

  MercuryPainter({
    required this.animation,
    required this.temperatureReduced,
  });

  void paintOneWave(
    Canvas canvas,
    Size size, {
    required double temperatureHeight,
    required double cyclicAnimationValue,
    required List<double> colorStops,
    required List<Color> colors,
  }) {
    assert(colorStops.length == colors.length);

    Path path = Path();

    path.moveTo(0, temperatureHeight);

    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        temperatureHeight +
            sin((i / size.width * 2 * pi) + (cyclicAnimationValue * 2 * pi)) *
                8,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    Paint paint = Paint();
    paint.shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, size.height),
      colors,
      colorStops,
    );

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final temperatureHeight = size.height - temperatureReduced * size.height;
    final paintColorStops = [0.0, 0.2, 0.4, 0.6, 0.8];

    paintOneWave(
      canvas,
      size,
      temperatureHeight: temperatureHeight,
      cyclicAnimationValue: (1 - animation),
      colorStops: paintColorStops,
      colors: [
        Colors.red.shade200,
        Colors.orange.shade200,
        Colors.yellow.shade200,
        Colors.green.shade200,
        Colors.blue.shade200,
      ],
    );
    paintOneWave(
      canvas,
      size,
      temperatureHeight: temperatureHeight,
      cyclicAnimationValue: animation,
      colorStops: paintColorStops,
      colors: [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.yellowAccent,
        Colors.greenAccent,
        Colors.blueAccent,
      ],
    );
  }

  @override
  bool shouldRepaint(MercuryPainter oldDelegate) =>
      animation != oldDelegate.animation ||
      temperatureReduced != oldDelegate.temperatureReduced;

  @override
  bool shouldRebuildSemantics(MercuryPainter oldDelegate) => false;
}
