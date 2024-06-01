import 'package:flutter/material.dart';

class DefaultPlaceHolder extends StatelessWidget {
  const DefaultPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.transparent,
      child: const CircularProgressIndicator(
        backgroundColor: Color.fromARGB(179, 5, 16, 51),
      ),
    );
  }
}

class DashedContainer extends StatelessWidget {
  const DashedContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShapePainter(),
      child: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.transparent,
        child: const CircularProgressIndicator(
          backgroundColor: Color.fromARGB(179, 5, 16, 51),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 9, startX = 0, startY = 0;
    final paint = Paint()
      ..color = const Color.fromARGB(133, 158, 158, 158)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }

    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
