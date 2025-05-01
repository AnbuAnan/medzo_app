import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/assistant_details.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/assistant_form_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class AssistantFormView extends ConsumerStatefulWidget {
  const AssistantFormView({super.key, this.assistant, this.isEditMode = false});

  final AssistantDetails? assistant;
  final bool isEditMode;

  @override
  AssistantFormViewState createState() => AssistantFormViewState();
}

class AssistantFormViewState extends ConsumerState<AssistantFormView> {
  final formKey = GlobalKey<FormState>();
  FocusNode pwFocusNode = FocusNode();
  bool isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.watch(assistantFormViewModelProvider.notifier);
      if (widget.isEditMode) {
        action.updateIsNameValidate(true);
        action.updateIsPhNoValidate(true);
        action.updateIsEmailValidate(true);
        action.updateIsDesignationValidate(true);
        action.updateIsEnterPwValidate(true);
        action.updateIsReEnterPwValidate(true);
        action.onPasswordChanged(widget.assistant!.password);

        action.updateIsEditMode(widget.isEditMode);
        action.updateIsEditModeDetails(widget.isEditMode, widget.assistant!);
      }
    });

    pwFocusNode.addListener(() {
      setState(() {
        isPasswordFocused = pwFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    pwFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(assistantFormViewModelProvider);
    var action = ref.read(assistantFormViewModelProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              action.updateIsEditMode(false);
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 2), () {
                action.clearFormField();
              });
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
          ),
          title: Text(
            widget.isEditMode
                ? Strings.assistantFormEditTitle
                : Strings.assistantFormCreateTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body:
            state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormNameLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
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
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w400,
                                ),
                                controller: state.assistantNameController,
                                onChanged: (value) {
                                  action.updateIsNameOnChanged(false);
                                  bool isValid =
                                      action.validateField(
                                        value: value,
                                        fieldName:
                                            Strings.assistantFormNameFieldValue,
                                        isName: true,
                                      ) ==
                                      null;
                                  action.updateIsNameValidate(isValid);
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorText:
                                      state.isNameOnchanged
                                          ? action.validateField(
                                            value:
                                                state
                                                    .assistantNameController
                                                    .text,
                                            fieldName:
                                                Strings
                                                    .assistantFormNameFieldValue,
                                            isName: true,
                                          )
                                          : null,
                                  hintText: Strings.assistantFormNameHind,
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                  errorStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormMobileLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
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
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 70, 68, 68),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: state.assistantMobileController,
                                onChanged: (value) {
                                  action.updateIsPoNoOnChanged(false);
                                  bool isValid =
                                      action.validateField(
                                        value: value,
                                        fieldName:
                                            Strings
                                                .assistantFormMobileFieldValue,
                                        isPhone: true,
                                      ) ==
                                      null;
                                  action.updateIsPhNoValidate(isValid);
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  errorText:
                                      state.isPhNoOnchanged
                                          ? action.validateField(
                                            value:
                                                state
                                                    .assistantMobileController
                                                    .text,
                                            fieldName:
                                                Strings
                                                    .assistantFormMobileFieldValue,
                                            isPhone: true,
                                          )
                                          : null,
                                  hintText: Strings.assistantFormMobileHint,
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                  errorStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormDesiginationLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
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
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 70, 68, 68),
                                ),
                                controller:
                                    state.assistantDesignationController,
                                onChanged: (value) {
                                  action.updateIsDesginationOnChanged(false);
                                  bool isValid =
                                      action.validateField(
                                        value: value,
                                        fieldName:
                                            Strings
                                                .assistantFormDesiginationFieldValue,
                                      ) ==
                                      null;
                                  action.updateIsDesignationValidate(isValid);
                                },
                                decoration: InputDecoration(
                                  errorText:
                                      state.isDesignationOnchanged
                                          ? action.validateField(
                                            value:
                                                state
                                                    .assistantDesignationController
                                                    .text,
                                            fieldName:
                                                Strings
                                                    .assistantFormDesiginationFieldValue,
                                          )
                                          : null,
                                  hintText:
                                      Strings.assistantFormDesiginationHint,
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                  errorStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormEmailLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall!.copyWith(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 70, 68, 68),
                                ),
                                controller: state.assistantEmailController,
                                onChanged: (value) {
                                  action.updateIsEmailOnChanged(false);
                                  bool isValid =
                                      action.validateField(
                                        value: value,
                                        fieldName:
                                            Strings
                                                .assistantFormEmailFieldValue,
                                        isEmail: true,
                                      ) ==
                                      null;
                                  action.updateIsEmailValidate(isValid);
                                },
                                decoration: InputDecoration(
                                  errorText:
                                      state.isEmailOnchanged
                                          ? action.validateField(
                                            value:
                                                state
                                                    .assistantEmailController
                                                    .text,
                                            fieldName:
                                                Strings
                                                    .assistantFormEmailFieldValue,
                                            isEmail: true,
                                          )
                                          : null,

                                  hintText: Strings.assistantFormEmailHint,
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                  errorStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormEnterPWLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    state.enterPasswordVisibilityNotifier,
                                builder: (context, isVisible, child) {
                                  return TextFormField(
                                    obscureText: !isVisible,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall!.copyWith(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                        255,
                                        70,
                                        68,
                                        68,
                                      ),
                                    ),
                                    controller:
                                        state.assistantEnterPwController,
                                    focusNode: pwFocusNode,
                                    onChanged: (value) {
                                      action.onPasswordChanged(value);
                                      action.updateIsEnterPwChanged(false);
                                      bool isValid =
                                          action.validateField(
                                            value: value,
                                            fieldName:
                                                Strings
                                                    .assistantFormEnterPWFieldValue,
                                            isPassword: true,
                                          ) ==
                                          null;
                                      action.updateIsEnterPwValidate(isValid);
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      errorText:
                                          state.isEnterPwOnchanged
                                              ? action.validateField(
                                                value:
                                                    state
                                                        .assistantEnterPwController
                                                        .text,
                                                fieldName:
                                                    Strings
                                                        .assistantFormEnterPWFieldValue,
                                                isPassword: true,
                                              )
                                              : null,
                                      hintText:
                                          Strings.assistantFormEnterPWHint,
                                      contentPadding: const EdgeInsets.all(14),
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          state
                                              .enterPasswordVisibilityNotifier
                                              .value = !isVisible;
                                        },
                                      ),
                                      errorStyle: Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2,
                                      ),
                                      errorMaxLines: 2,
                                      hintStyle: Theme.of(
                                        context,
                                      ).textTheme.labelSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              if (isPasswordFocused) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            state.pwHasEightDigit
                                                ? Colors.green
                                                : Colors.transparent,
                                        border:
                                            state.pwHasEightDigit
                                                ? Border.all(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.secondary,
                                                )
                                                : Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      Strings.assistantFormPwRulesOne,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            state.pwHasOneLowerCase
                                                ? Colors.green
                                                : Colors.transparent,
                                        border:
                                            state.pwHasOneLowerCase
                                                ? Border.all(
                                                  color: Colors.transparent,
                                                )
                                                : Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      Strings.assistantFormPwRulesTwo,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            state.pwHasOneUpperCase
                                                ? Colors.green
                                                : Colors.transparent,
                                        border:
                                            state.pwHasOneUpperCase
                                                ? Border.all(
                                                  color: Colors.transparent,
                                                )
                                                : Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      Strings.assistantFormPwRulesThree,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            state.pwHasOneSpecialCharacter
                                                ? Colors.green
                                                : Colors.transparent,
                                        border:
                                            state.pwHasOneSpecialCharacter
                                                ? Border.all(
                                                  color: Colors.transparent,
                                                )
                                                : Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      Strings.assistantFormPwRulesFour,
                                      maxLines: 2,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color:
                                            state.pwHasOneNumber
                                                ? Colors.green
                                                : Colors.transparent,
                                        border:
                                            state.pwHasOneNumber
                                                ? Border.all(
                                                  color: Colors.transparent,
                                                )
                                                : Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      Strings.assistantFormPwRulesFive,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  text: Strings.assistantFormReEnterPWLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Strings.mandatorySymbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    state.reEnterPasswordVisibilityNotifier,
                                builder: (context, isVisible, child) {
                                  return TextFormField(
                                    obscureText: !isVisible,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall!.copyWith(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                        255,
                                        70,
                                        68,
                                        68,
                                      ),
                                    ),
                                    controller:
                                        state.assistantReEnterPwController,
                                    onChanged: (value) {
                                      action.updateIsReEnterPwOnChanged(false);
                                      bool isValid =
                                          action.validateField(
                                            value: value,
                                            fieldName:
                                                Strings
                                                    .assistantFormReEnterPWFieldValue,
                                            isReEnterPassword: true,
                                            passwordToMatch:
                                                state
                                                    .assistantEnterPwController
                                                    .text,
                                          ) ==
                                          null;
                                      action.updateIsReEnterPwValidate(isValid);
                                    },
                                    decoration: InputDecoration(
                                      errorText:
                                          state.isReEnterPwOnchanged
                                              ? action.validateField(
                                                value:
                                                    state
                                                        .assistantReEnterPwController
                                                        .text,
                                                fieldName:
                                                    Strings
                                                        .assistantFormReEnterPWFieldValue,
                                                isReEnterPassword: true,
                                                passwordToMatch:
                                                    state
                                                        .assistantEnterPwController
                                                        .text,
                                              )
                                              : null,
                                      hintText:
                                          Strings.assistantFormReEnterPWHint,
                                      contentPadding: const EdgeInsets.all(14),
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          state
                                              .reEnterPasswordVisibilityNotifier
                                              .value = !isVisible;
                                        },
                                      ),
                                      errorStyle: Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: Theme.of(
                                        context,
                                      ).textTheme.labelSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary, // Color when the field is enabled
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary, // Color when the field is enabled
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .error, // Color when the field is focused and there's an error
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              GradientButton(
                                buttonText:
                                    (widget.isEditMode
                                        ? Strings.assistantFormSaveBtn
                                        : Strings.assistantFormcreateBtn),
                                onPressed: () {
                                  action.assistandCreateAndUpdate(
                                    context,
                                    details: widget.assistant,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
