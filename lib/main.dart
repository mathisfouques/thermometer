import 'package:flutter/material.dart';

import 'slider.dart';
import 'thermometer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ValueNotifier<double> temperature = ValueNotifier(0.5);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SliderTemperature(temperature),
              Thermometer(temperature)
            ],
          ),
        ),
      ),
    );
  }
}
