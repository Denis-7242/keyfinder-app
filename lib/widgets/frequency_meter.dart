import 'package:flutter/material.dart';
import 'dart:math' as math;

class FrequencyMeter extends StatelessWidget {
  final double frequency;
  final bool isActive;

  const FrequencyMeter({
    Key? key,
    required this.frequency,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Normalize frequency to 0-1 range (assuming 80-800 Hz range)
    double normalizedFreq = ((frequency - 80) / 720).clamp(0.0, 1.0);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 60,
      child: CustomPaint(
        painter: _FrequencyMeterPainter(
          value: normalizedFreq,
          isActive: isActive,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Container(),
      ),
    );
  }
}

class _FrequencyMeterPainter extends CustomPainter {
  final double value;
  final bool isActive;
  final Color primaryColor;
  final Color secondaryColor;

  _FrequencyMeterPainter({
    required this.value,
    required this.isActive,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    Paint bgPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    RRect bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(30),
    );
    canvas.drawRRect(bgRect, bgPaint);

    if (isActive && value > 0) {
      // Active indicator
      Paint activePaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor],
        ).createShader(Rect.fromLTWH(0, 0, size.width * value, size.height))
        ..style = PaintingStyle.fill;
      
      RRect activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * value, size.height),
        const Radius.circular(30),
      );
      canvas.drawRRect(activeRect, activePaint);
    }

    // Draw tick marks
    Paint tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 10; i++) {
      double x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, size.height - 10),
        Offset(x, size.height - 5),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FrequencyMeterPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.isActive != isActive;
  }
}