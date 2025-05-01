
import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  static final AppLifecycleObserver _instance = AppLifecycleObserver._internal();

  factory AppLifecycleObserver() {
    return _instance;
  }

  AppLifecycleObserver._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusManager.instance.primaryFocus?.unfocus(); // Dismiss keyboard
    }
  }
}