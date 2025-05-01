import 'package:flutter/material.dart';
import 'package:medzo/model/content_item.dart';

class Onboarding{
  final ContentItems contentItems;
  final PageController pageController;
  final int indexValue;
  final bool isLastPage;

  Onboarding({
    required this.contentItems,
    required this.pageController,
    required this.indexValue,
    required this.isLastPage,
  });
}