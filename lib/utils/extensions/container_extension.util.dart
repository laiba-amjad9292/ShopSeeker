// ignore_for_file: camel_case_extensions, unnecessary_this

import 'package:flutter/material.dart';

extension decorationExtensionSizedBox on SizedBox {
  Widget bordered({
    double radius = 0,
    Color color = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1,
    double spreadRadius = 0.0,
    bool showBorder = true,
    BoxBorder? border,
    double blurRadius = 0.0,
    Offset offset = const Offset(0, 0),
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets margin = EdgeInsets.zero,
  }) => Container(
    margin: margin,
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border:
          showBorder
              ? border ?? Border.all(color: borderColor, width: borderWidth)
              : null,
      boxShadow: [
        if (spreadRadius != 0)
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: offset,
          ),
      ],
    ),
    child: this,
  );
}

extension decorationExtensionContainer on Container {
  Widget bordered({
    double radius = 0,
    Color color = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
    bool showBorder = true,
    bool showShadow = false,
    Offset offset = const Offset(0, 0),
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets margin = EdgeInsets.zero,
  }) => Container(
    margin: margin,
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border:
          showBorder
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
      boxShadow: [
        if (showShadow == true)
          BoxShadow(
            color: const Color(0x00000000).withOpacity(0.20),
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
      ],
    ),
    child: this,
  );
}
