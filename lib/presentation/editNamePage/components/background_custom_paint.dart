
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    final paint0 = Paint()
      ..shader = LinearGradient(
          colors: [Colors.greenAccent, Colors.blueAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.5, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
      ).createShader(Rect.fromLTRB(11, 42, 1000, 23));

    Path path0 = Path();
    path0.moveTo(size.width*1.0001125,size.height*0.2023600);
    path0.quadraticBezierTo(size.width*0.8241750,size.height*0.1836800,size.width*0.7938625,size.height*0.3783600);
    path0.cubicTo(size.width*0.7712500,size.height*0.5130200,size.width*0.7998000,size.height*0.6008600,size.width*0.6538625,size.height*0.6783600);
    path0.cubicTo(size.width*0.5688625,size.height*0.7138600,size.width*0.4385750,size.height*0.7370600,size.width*0.3138625,size.height*0.7003600);
    path0.quadraticBezierTo(size.width*0.1069875,size.height*0.6113600,size.width*0.0063625,size.height*1.0003600);
    path0.lineTo(size.width*1.0001125,size.height*1.0003600);
    path0.lineTo(size.width*1.0001125,size.height*0.2023600);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
