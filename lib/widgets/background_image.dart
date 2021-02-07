import 'dart:ui';
import 'package:enkom/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


Widget back(Widget back){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          alignment: Alignment.bottomCenter,
          image: ExactAssetImage("assets/images/city.png"),
          fit: BoxFit.cover),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6.0,sigmaY: 6.0),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: darkBlue.withOpacity(0.7)),
        child: SingleChildScrollView(
          child: SafeArea(child: back),
        ),
      ),
    ),
  );
}