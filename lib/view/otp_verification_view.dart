import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/otp_verification_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';
import 'package:medzo/widgets/linear_progress.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
  const OtpVerificationView({super.key, required this.phNumber});

  final String phNumber;

  @override
  OtpVerificationViewState createState() => OtpVerificationViewState();
}

class OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var action = ref.read(otpVerificationViewModelProvider.notifier);
      action.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authAction = ref.read(authProvider.notifier);
    final state = ref.watch(otpVerificationViewModelProvider);
    final action = ref.read(otpVerificationViewModelProvider.notifier);

    Widget content = TextButton(
      onPressed:
          state.isResendButtonDisabled
              ? null
              : () {
                action.updateIsVerifying(false);
                action.resendOtp(context, widget.phNumber);
              },
      child: Text(
        Strings.otpResendBtn,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w400,
          color:
              state.isResendButtonDisabled
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                action.updateIsVerifying(false);
                Navigator.of(context).popUntil((route) {
                  bool shouldPop = Navigator.of(context).canPop();
                  if (shouldPop) {
                    Navigator.of(context).pop();
                    return true;
                  }
                  return false;
                });
              },
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            title: const LinearProgress(pageNumber: 2, value: 0.66),
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      Strings.otpHeadline,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Strings.otpDescription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Form(
                          key: state.formKey,
                          child: OtpPinField(
                            key: state.otpKey,
                            maxLength: 6,
                            showCursor: !state.isVerifying ? true : false,
                            autoFocus: true,
                            otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                            otpPinFieldStyle: OtpPinFieldStyle(
                              fieldBorderRadius: 10,
                              fieldPadding: 8,
                              fieldBorderWidth: 1,
                              textStyle: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                              ),
                              filledFieldBorderColor:
                                  Theme.of(context).colorScheme.primary,
                              activeFieldBorderColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onChange: (value) {
                              action.updateMismatchError(false);
                              action.updateOtp(value);
                            },
                            onSubmit: (value) {
                              //Automatically call the api
                              // action.verifyingOtp(widget.phNumber, context,
                              //     authAction.login, authAction.saveProfile);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: Strings.otpTimerLabel, 
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500, 
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${Strings.otpTimerHour}${state.counter > 9 ? state.counter : '${Strings.otpTimerMinute}${state.counter}'}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w400, 
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      buttonText:
                          state.isVerifying
                              ? Strings.otpVerifyingBtn
                              : Strings.otpVerifyBtn,
                      
                      onPressed:
                          state.isVerifying
                              ? () {}
                              : () {
                                (state.otp != null && state.otp!.length == 6)
                                    ? action.verifyingOtp(
                                      widget.phNumber,
                                      context,
                                      authAction.login,
                                      authAction.saveProfile,
                                    )
                                    : null;
                              },
                      isLoading: state.isVerifying,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.otpNotReceived,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        content,
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (state.mismtachError)
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onError,
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 6,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outlined,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                Strings.otpErrorMsg,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
