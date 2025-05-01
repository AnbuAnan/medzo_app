import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/onboarding_view.dart';
import 'package:medzo/view/phone_number_verification_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Strings.appRoutePhNoVerify:
      return MaterialPageRoute(
          builder: (_) => const PhoneNumberVerificationView());
    default:
      return MaterialPageRoute(
        builder: (_) => const OnboardingView(),
      );
  }
}
