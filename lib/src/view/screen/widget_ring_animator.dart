import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetRingAnimator extends StatefulWidget {
  const WidgetRingAnimator(
      {required this.child,
      this.ringColor = Colors.deepOrange,
      this.ringAnimation = Curves.linear,
      this.ringAnimationInSeconds = 30,
      this.ringIconsSize = 3,
      this.size = 250,
      this.reverse = true,
      required this.ringIcons,
      this.ringIconsColor = Colors.black})
      : assert(child != null);

  final Color ringColor;
  final Curve ringAnimation;
  final int ringAnimationInSeconds;
  final List<String> ringIcons;
  final Color ringIconsColor;
  final double ringIconsSize;
  final double size;
  final Widget child;
  final bool reverse;

  @override
  _WidgetAnimatorState createState() => _WidgetAnimatorState();
}

class _WidgetAnimatorState extends State<WidgetRingAnimator>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  List<UI.Image> image = <UI.Image>[];

  @override
  void initState() {
    super.initState();
    initAnimations();
    initUiImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          _ringArc(),
          _child(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Center _child() {
    return Center(
      child: Container(
        width: widget.size * 0.9,
        height: widget.size * 0.9,
        child: widget.child,
      ),
    );
  }

  Center _ringArc() {
    return Center(
      child: RotationTransition(
        turns: animation,
        child: CustomPaint(
          painter: Arc2Painter(
              color: widget.ringColor,
              iconsSize: widget.ringIconsSize,
              image: image,
              imageColor: widget.ringIconsColor),
          child: Container(
            width: widget.size,
            height: widget.size,
          ),
        ),
      ),
    );
  }

  Future _loadUiImage(String imageAssetPath) async {
    final data = await rootBundle.load(imageAssetPath);
    final bytes = data.buffer.asUint8List();
    final decodeImage = await decodeImageFromList(bytes);
    image.add(decodeImage);

    setState(() {
      image = image;
    });
  }

  void initUiImages() async {
    for (var imageAssetPath in widget.ringIcons) {
      await _loadUiImage(imageAssetPath);
    }
  }

  void initAnimations() {
    controller = AnimationController(
        duration: Duration(seconds: widget.ringAnimationInSeconds),
        vsync: this);

    final _ringAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: widget.ringAnimation)));

    // reverse or same direction animation
    widget.reverse
        ? animation = ReverseAnimation(_ringAnimation)
        : animation = _ringAnimation;

    controller.repeat();
  }
}

class Arc2Painter extends CustomPainter {
  Arc2Painter(
      {required this.color,
      this.iconsSize = 3,
      required this.image,
      required this.imageColor});

  final Color color;
  final double iconsSize;
  final List<UI.Image> image;
  final Color imageColor;

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final ColorFilter filter = ColorFilter.mode(imageColor, BlendMode.srcATop);

    // Helper function to convert degrees to radians
    double degreesToRads(num deg) {
      return deg * (pi / 180.0).toDouble();
    }

    // Draw the ring arc
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawArc(
      rect,
      degreesToRads(0), // startAngle (0 degrees for a full circle)
      degreesToRads(360), // sweepAngle (full circle)
      false,
      p,
    );

    // Draw the images (icons) above the ring
    final Offset center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final noOfImages = image.length;
    final arcAngle = 360 / noOfImages;

    for (var i = 0; i < noOfImages; i++) {
      final double radians = degreesToRads(i * arcAngle);
      final Offset pointOnArc = Offset(
        radius * math.cos(radians) + center.dx,
        radius * math.sin(radians) + center.dy,
      );

      // Save the current canvas state
      canvas.save();

      // Move the canvas origin to the point on the arc
      canvas.translate(pointOnArc.dx, pointOnArc.dy);

      // Rotate the canvas by the negative of the angle to keep the icon upright
      canvas.rotate(-radians);

      // Scale the icons based on iconsSize
      final double iconWidth = image[i].width * iconsSize;
      final double iconHeight = image[i].height * iconsSize;

      // Draw the scaled image, centered at the new translated origin
      canvas.drawImageRect(
        image[i],
        Rect.fromLTWH(
            0, 0, image[i].width.toDouble(), image[i].height.toDouble()),
        Rect.fromCenter(
            center: Offset(0, 0), width: iconWidth, height: iconHeight),
        Paint()..colorFilter = filter,
      );

      // Restore the canvas to its previous state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
