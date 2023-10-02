import 'dart:math';

import 'package:flutter/material.dart';

class SliderTemperature extends StatelessWidget {
  final ValueNotifier<double> temperature;

  const SliderTemperature(this.temperature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: min(200, MediaQuery.of(context).size.width / 2 - 20),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sliderMaxY = constraints.maxHeight - 100;
          double startingPositionY = temperature.value * sliderMaxY;

          return AnimatedBuilder(
            animation: temperature,
            builder: (context, _) {
              final sliderPositionY = temperature.value * sliderMaxY;

              return Stack(
                children: [
                  Positioned(
                    bottom: sliderPositionY,
                    right: 20,
                    child: GestureDetector(
                      onVerticalDragStart: (startDetails) {
                        startingPositionY = sliderPositionY;
                      },
                      onVerticalDragEnd: (endDetails) {},
                      onVerticalDragUpdate: (updateDetails) {
                        final newSliderPositionY =
                            startingPositionY - updateDetails.localPosition.dy;
                        final newSliderRelativePosition =
                            newSliderPositionY / sliderMaxY;
                        temperature.value =
                            max(0, min(1, newSliderRelativePosition));
                      },
                      child: BubbleTemperatureIndicator(
                        temperature: (temperature.value * 100).floor(),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class BubbleTemperatureIndicator extends StatelessWidget {
  final int temperature;

  const BubbleTemperatureIndicator({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: BubblePainter(),
        child: Center(
          child: Text(
            "$temperature °",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      center,
      size.width / 2 - 15,
      Paint()..color = Colors.black,
    );

    var path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(center.dx, center.dy + 20);
    path.lineTo(center.dx, center.dy - 20);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BubblePainter oldDelegate) => false;
}
