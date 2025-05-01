import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/assistant_login_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class AssistantLoginView extends ConsumerStatefulWidget {
  const AssistantLoginView({super.key});

  @override
  AssistantLoginViewState createState() => AssistantLoginViewState();
}

class AssistantLoginViewState extends ConsumerState<AssistantLoginView> {
  @override
  Widget build(BuildContext context) {
    var authAction = ref.read(authProvider.notifier);
    var state = ref.watch(assistantLoginViewModelProvider);
    var action = ref.read(assistantLoginViewModelProvider.notifier);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              action.clearState();
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
          ),
          title: Text(
            Strings.assistantLoginAppBarText,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.assistantLoginHeadline,
                        style: Theme.of(context).textTheme.displaySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Strings.assistantLoginDescription,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: state.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: Strings.assistantLoginUserNameLabelText,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                ),
                                children: [
                                  TextSpan(
                                    text: Strings.mandatorySymbol,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
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
                                fontWeight: FontWeight.w400,
                                letterSpacing: 01,
                              ),
                              controller: state.phNumberController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                errorText:
                                    state.isPhNumValidated
                                        ? action.validatePhNum(
                                          state.phNumberController.text,
                                        )
                                        : null,
                                hintText:
                                    Strings.assistantLoginUserNameLabelText,
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: (value) {
                                action.updateisPhNumValidated(false);
                                action.updateMismatchError(false);
                              },
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                text: Strings.assistantLoginPasswordLabelText,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                ),
                                children: [
                                  TextSpan(
                                    text: Strings.mandatorySymbol,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              obscureText: !state.isPasswordVisible,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.6,
                              ),
                              controller: state.passwordController,
                              decoration: InputDecoration(
                                errorText:
                                    state.isPwValidated
                                        ? action.validatePw(
                                          state.passwordController.text,
                                        )
                                        : null,
                                hintText:
                                    Strings.assistantLoginPasswordPlaceholder,
                                contentPadding: const EdgeInsets.all(14),
                                isDense: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    action.updateIsPasswordVisible();
                                  },
                                ),
                                errorStyle: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                hintStyle: Theme.of(
                                  context,
                                ).textTheme.labelSmall!.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: (value) {
                                action.updateisPwValidated(false);
                                action.updateMismatchError(false);
                              },
                            ),
                            const SizedBox(height: 36),
                            if (state.mismatchError)
                              Container(
                                width: double.infinity,
                                height: 65,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onError,
                                  border: Border(
                                    left: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      width: 6,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        Strings
                                            .assistantInvalidCredentialErrorMsg,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GradientButton(
                        buttonText:
                            state.isVerifying
                                ? Strings.loggingBtnText
                                : Strings.loginBtnText,
                        onPressed:
                            state.isVerifying
                                ? () {}
                                : () {
                                  action.verifyAssistant(
                                    context,
                                    authAction.login,
                                    authAction.saveProfile,
                                  );
                                },
                        isLoading: state.isVerifying,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
