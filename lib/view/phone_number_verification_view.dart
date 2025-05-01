import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/assistant_login_view.dart';
import 'package:medzo/viewModel/phone_number_verification_view_model.dart';
import 'package:medzo/widgets/terms_condition.dart';
import 'package:medzo/widgets/subscribe_card.dart';
import 'package:medzo/widgets/linear_progress.dart';
import 'package:medzo/widgets/gradient_button.dart';

class PhoneNumberVerificationView extends ConsumerStatefulWidget {
  const PhoneNumberVerificationView({super.key});

  @override
  PhoneNumberVerificationViewState createState() =>
      PhoneNumberVerificationViewState();
}

class PhoneNumberVerificationViewState
    extends ConsumerState<PhoneNumberVerificationView>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusManager.instance.primaryFocus?.unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneNumberVerificationViewModelProvider);
    final action = ref.read(phoneNumberVerificationViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          title: const LinearProgress(pageNumber: 1, value: 0.33),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    Strings.verifyHeadline,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Strings.verifyDescription,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: Strings.enterPhoneNumberLabel,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              color:
                                  state.hasError
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                            ),
                            children: [
                              TextSpan(
                                text: Strings.mandatorySymbol,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            letterSpacing: 1,
                            color:
                                state.hasError
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                          ),
                          controller: state.phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            errorText:
                                state.isValidated
                                    ? action.validatePhNum(
                                      state.phoneNumberController.text,
                                    )
                                    : null,
                            hintText: Strings.enterPhoneNumberFieldPlaceholder,
                            contentPadding: const EdgeInsets.all(14),
                            isDense: true,
                            errorStyle: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            hintStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              letterSpacing: 1,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    state.hasError
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    state.hasError
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    state.hasError
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            action.updateHasError(false);
                            action.updateNotUserMessage(null);
                            action.updateIsValidated(false);
                            // if (value.length >= 10) {
                            //   FocusManager.instance.primaryFocus?.unfocus();
                            // }
                          },
                        ),
                        if (state.notUserMessage != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            state.notUserMessage!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                side: BorderSide.none,
                                shape: const CircleBorder(
                                  eccentricity: sqrt1_2,
                                ),
                                fillColor: WidgetStateProperty.all(
                                  state.isAgreeChecked
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.secondaryFixed,
                                ),
                                value: state.isAgreeChecked,
                                onChanged: (value) {
                                  action.updateIsAgreeChecked(value!);
                                  action.updateCheckBoxValidatorMessage(null);
                                },
                              ),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          Strings.termsAndConditionDisclamier1,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) =>
                                                        const TermsAndConditions(),
                                              );
                                            },
                                    ),
                                    TextSpan(
                                      text:
                                          Strings.termsAndConditionDisclamier2,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.checkBoxValidatorMessage != null)
                          Text(
                            state.checkBoxValidatorMessage!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  GradientButton(
                    buttonText:
                        state.isVerifying
                            ? Strings.loggingBtnText
                            : Strings.loginBtnText,
                    onPressed:
                        state.isVerifying
                            ? () {}
                            : () {
                              action.verifyingPhoneNumber(context);
                            },
                    isLoading: state.isVerifying,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.lineLeft),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryFixed,
                        radius: 12,
                        child: Text(
                          Strings.verifyOrText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset(Images.lineRight),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 1.0],
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.primaryFixedDim,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed:
                          state.isVerifying
                              ? () {}
                              : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const AssistantLoginView(),
                                  ),
                                );
                              },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.assistantLoginBtnText,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color.fromARGB(
                              255,
                              39,
                              31,
                              224,
                            ),
                            child: Image.asset(Images.assistantBtnArrow),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Column(
                    children: [SubscribeCard(), SizedBox(height: 12)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
