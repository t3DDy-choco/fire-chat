import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fire_chat/particles/component/painter.dart';

class CircularParticle extends StatefulWidget {
  CircularParticle({
    required Key key,
    required this.height,
    required this.width,
    this.onTapAnimation = true,
    this.numberOfParticles = 500,
    this.speedOfParticles = 2,
    this.awayRadius = 100,
    required this.isRandomColor,
    this.particleColor = Colors.white,
    this.awayAnimationDuration = const Duration(milliseconds: 600),
    this.maxParticleSize = 4,
    this.isRandSize = false,
    this.randColorList = const [
      Colors.black,
      Colors.blue,
      Colors.white,
      Colors.red,
      Colors.green,
    ],
    this.awayAnimationCurve = Curves.easeIn,
    this.enableHover = false,
    this.hoverColor = Colors.orangeAccent,
    this.hoverRadius = 80,
    this.connectDots = false,
  }) : super(key: key);
  final double awayRadius;
  final double height;
  final double width;
  final bool onTapAnimation;
  final double numberOfParticles;
  final double speedOfParticles;
  final bool isRandomColor;
  final Color particleColor;
  final Duration awayAnimationDuration;
  final Curve awayAnimationCurve;
  final double maxParticleSize;
  final bool isRandSize;
  final List<Color> randColorList;
  final bool enableHover;
  final Color hoverColor;
  final double hoverRadius;
  final bool connectDots; //not recommended

  _CircularParticleState createState() => _CircularParticleState();
}

class _CircularParticleState extends State<CircularParticle>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  List<Offset> offsets = [];
  List<bool> randDirection = [];
  double speedOfparticle = 0;
  var rng = new Random();
  double randValue = 0;
  late double dx;
  late double dy;
  List<double> randomDouble = [];
  _CircularParticleState();
  List<double> randomSize = [];
  List<int> hoverIndex = [];
  List<List> lineOffset = [];

  initailizeOffsets(_) {
    for (int index = 0; index < widget.numberOfParticles; index++) {
      offsets.add(Offset(
          rng.nextDouble() * widget.width, rng.nextDouble() * widget.height));
      randomDouble.add(rng.nextDouble());
      randDirection.add(rng.nextBool());
      randomSize.add(rng.nextDouble());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(initailizeOffsets);
    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          speedOfparticle = widget.speedOfParticles;
          for (int index = 0; index < offsets.length; index++) {
            if (randDirection[index]) {
              randValue = -speedOfparticle;
            } else {
              randValue = speedOfparticle;
            }
            dx = offsets[index].dx + (randValue * randomDouble[index]);
            dy = offsets[index].dy + randomDouble[index] * speedOfparticle;
            if (dx > widget.width) {
              dx = dx - widget.width;
            } else if (dx < 0) {
              dx = dx + widget.width;
            }
            if (dy > widget.height) {
              dy = dy - widget.height;
            } else if (dy < 0) {
              dy = dy + widget.height;
            }
            offsets[index] = Offset(dx, dy);
          }
          if (widget.connectDots) connectLines(); //not recommended
        });
      });
    controller.repeat();
    changeDirection();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  changeDirection() async {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 600));

      for (int index = 0; index < widget.numberOfParticles; index++) {
        randDirection[index] = (rng.nextBool());
      }
      return true;
    });
  }

  connectLines() {
    lineOffset = [];
    double distanceBetween = 0;
    for (int point1 = 0; point1 < offsets.length; point1++) {
      for (int point2 = 0; point2 < offsets.length; point2++) {
        //    if(offsets)
        distanceBetween = sqrt(
            pow((offsets[point2].dx - offsets[point1].dx), 2) +
                pow((offsets[point2].dy - offsets[point1].dy), 2));
        if (distanceBetween < 50) {
          lineOffset.add([offsets[point1], offsets[point2], distanceBetween]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          painter: ParticlePainter(
              offsets: offsets,
              isRandomColor: widget.isRandomColor,
              particleColor: widget.particleColor,
              maxParticleSize: widget.maxParticleSize,
              randSize: randomSize,
              isRandSize: widget.isRandSize,
              randColorList: widget.randColorList,
              lineOffsets: lineOffset),
        ),
      ),
    );
  }
}
