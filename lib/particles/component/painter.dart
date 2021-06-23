import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  final List<Offset> offsets;
  final bool isRandomColor;
  final Color particleColor;
  final Paint constColorPaint;
  final double maxParticleSize;
  static Color randomColor = Colors.blue;
  static late Paint randomColorPaint;
  final List<double> randSize;
  final bool isRandSize;
  final List<Color> randColorList;
  final List<List> lineOffsets;

  ParticlePainter({
    required this.randColorList,
    required this.isRandSize,
    required this.maxParticleSize,
    required this.offsets,
    required this.isRandomColor,
    required this.particleColor,
    required this.randSize,
    required this.lineOffsets,
  }) : constColorPaint = Paint()..color = particleColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < offsets.length; index++) {
      if (isRandomColor) {
        randomColor = randColorList[index % randColorList.length];

        randomColorPaint = Paint()..color = randomColor;
        canvas.drawCircle(
            offsets[index],
            isRandSize ? maxParticleSize * (randSize[index]) : maxParticleSize,
            constColorPaint);
      } else {
        randomColorPaint = Paint()..color = randomColor;
        canvas.drawCircle(
            offsets[index],
            isRandSize ? maxParticleSize * (randSize[index]) : maxParticleSize,
            constColorPaint);
      }
    }
    lineOffsets.forEach(
      (item) {
        randomColorPaint = Paint()
          ..color = particleColor
          ..strokeWidth = (4 * (1 - item[2] / 50)).toDouble();
        canvas.drawLine(item[0], item[1], randomColorPaint);
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
