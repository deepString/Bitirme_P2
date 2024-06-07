import 'package:flutter/material.dart';

enum Screens {mobile, tablet, desktop}

detectScreen(Size size) {
  if (size.width < 600) {
    return Screens.mobile;
  }
  else if (size.width < 840) {
    return Screens.tablet;
  }
  else {
    return Screens.desktop;
  }
}