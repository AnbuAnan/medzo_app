import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/onboarding_view_model.dart';
import 'package:medzo/widgets/skip_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:medzo/widgets/gradient_button.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  OnboardingViewState createState() => OnboardingViewState();
}

class OnboardingViewState extends ConsumerState<OnboardingView> {
  @override
  void initState() {
    super.initState();

    // Set status bar to transparent with black icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(onboardingViewModelProvider);
    var action = ref.read(onboardingViewModelProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, 
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                state.contentItems.contents[state.indexValue].image,
                fit: BoxFit.cover,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: SmoothPageIndicator(
                    controller: state.pageController,
                    count: state.contentItems.contents.length,
                    onDotClicked: (index) => state.pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                    ),
                    effect: WormEffect(
                      type: WormType.underground,
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor:
                          Theme.of(context).colorScheme.surfaceContainerHigh,
                      paintStyle: PaintingStyle.stroke,
                      dotColor:
                          Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 145,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      action.updateIndexValue(index);
                      action.updateIsLastPage(
                          state.contentItems.contents.length - 1 == index);
                    },
                    itemCount: state.contentItems.contents.length,
                    controller: state.pageController,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  Text(
                                    state.contentItems.contents[index].title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.contentItems.contents[index]
                                        .descriptions,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          height: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 9, right: 9),
                  child: Column(
                    children: [
                      SizedBox(
                        height: state.isLastPage ? 96 : 36,
                      ),
                      GradientButton(
                        buttonIcon: Icons.arrow_right_alt_rounded,
                        buttonText: state.isLastPage
                            ? Strings.letsStartBtnText
                            : Strings.nextBtnText,
                        onPressed: state.isLastPage
                            ? () {
                                action.moveToNextScreen(context);
                              }
                            : () => state.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                ),
                      ),

                      if (!state.isLastPage)
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            SkipButton(
                              buttonText: Strings.skipBtnText,
                              onpressed: () {
                                action.moveToNextScreen(context);
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}