import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Images.splashLogo);
  }
}