import 'package:flutter/material.dart';

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
   Path path = new Path();

   path.lineTo(0, size.height-25*7) ;
   path.quadraticBezierTo(size.width, size.height, size.width, size.height-300) ;


   path.lineTo(size.width, 0) ;


    return path ;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }



}