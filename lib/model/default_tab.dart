import 'package:flutter/material.dart';

class DefaultTab {
  final int selectedPageIndex;
  final Widget activePage;
  final String activePageTitle;

  DefaultTab({
    required this.selectedPageIndex,
    required this.activePage,
    required this.activePageTitle,
  });

  DefaultTab copyWith({
    int? selectedPageIndex,
    Widget? activePage,
    String? activePageTitle,
    
  }) {
    return DefaultTab(
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
      activePage: activePage ?? this.activePage,
      activePageTitle: activePageTitle ?? this.activePageTitle,
    );
  }
}
