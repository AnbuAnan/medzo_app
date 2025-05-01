import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/onboarding.dart';
import 'package:medzo/model/content_item.dart';
import 'package:medzo/view/phone_number_verification_view.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingViewModel extends StateNotifier<Onboarding> {
  OnboardingViewModel()
      : super(Onboarding(
          contentItems: ContentItems(),
          pageController: PageController(),
          indexValue: 0,
          isLastPage: false,
        ));

  void updateIndexValue(int value) {
    state = Onboarding(
      contentItems: state.contentItems,
      pageController: state.pageController,
      indexValue: value,
      isLastPage: state.isLastPage,
    );
  }

  void updateIsLastPage(bool value) {
    state = Onboarding(
      contentItems: state.contentItems,
      pageController: state.pageController,
      indexValue: state.indexValue,
      isLastPage: value,
    );
  }

  void moveToNextScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageTransition(
        duration: const Duration(milliseconds: 400),
        type: PageTransitionType
            .rightToLeftWithFade, 
        child: const PhoneNumberVerificationView(),
      ),
    );
  }
}

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, Onboarding>((ref) {
  return OnboardingViewModel();
});
