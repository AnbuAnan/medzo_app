import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/registered_user_form_view.dart';
import 'package:medzo/viewModel/register_form_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class RegisterFormView extends ConsumerStatefulWidget {
  const RegisterFormView({super.key, required this.date, this.time});

  final DateTime date;
  final TimeSlot? time;

  @override
  RegisterFormViewState createState() => RegisterFormViewState();
}

class RegisterFormViewState extends ConsumerState<RegisterFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registerFormViewModelProvider);
    var action = ref.read(registerFormViewModelProvider.notifier);
    var authState = ref.watch(authProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: Strings.registerFormAadharLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: ' ${Strings.optnltxt}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            TextFormField(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.6,
              ),
              enabled: !state.isRegistering,
              controller: state.aadharController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: Strings.registerFormAadharPlaceHolder,
                contentPadding: const EdgeInsets.all(14),
                isDense: true,
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .error, 
                  ),
                ),
              ),
             ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: Strings.registerFormNameLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text:  Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.6,
              ),
              enabled: !state.isRegistering,
              controller: state.nameController,
              onChanged: (value) {
                action.updateIsNameOnchanged(false);
                bool isValid =
                    action.validateField(
                      value: value,
                      fieldName: Strings.registerFormNameLabel,
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
                          value: state.nameController.text,
                          fieldName: Strings.registerFormNameLabel,
                          isName: true,
                        )
                        : null,
                hintText: Strings.registerFormNamePlaceHolder,
                contentPadding: const EdgeInsets.all(14),
                isDense: true,
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .error, 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: Strings.registerFormMobileNumberLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text:Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                letterSpacing: 0.6,
                fontWeight: FontWeight.w400,
              ),
              enabled: !state.isRegistering,
              controller: state.phController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                action.updateIsPhNoOnchanged(false);
                bool isValid =
                    action.validateField(
                      value: value,
                      fieldName: Strings.userProfileMobileLabel,
                      isPhone: true,
                    ) ==
                    null;
                action.updateIsPhNoValidate(isValid);
              },
              decoration: InputDecoration(
                errorText:
                    state.isPhNoOnchanged
                        ? action.validateField(
                          value: state.phController.text,
                          fieldName: Strings.registerFormMobileNumberLabel,
                          isPhone: true,
                        )
                        : null,
                hintText: Strings.registerFormMobileNumberPlaceHolder,
                contentPadding: const EdgeInsets.all(14),
                isDense: true,
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: Strings.registerFormDobLabel,
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text:  Strings.mandatorySymbol,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.6,
                        ),
                        readOnly: true,
                        enabled: !state.isRegistering,
                        controller: state.dobController,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          state.isRegistering
                              ? null
                              : action.selectDOB(context);
                        },
                        onChanged: (value) {
                          action.updateIsDobOnchanged(false);
                          bool isValid =
                              action.validateField(
                                value: state.dobController.text,
                                fieldName:Strings.registerFormDobLabel,
                                isDob: true,
                              ) ==
                              null;
                          debugPrint('$isValid');
                          action.updateIsDobValidate(isValid);
                          action.onDOBTextChanged();
                        },
                        decoration: InputDecoration(
                          errorMaxLines: 2,

                          errorText:
                              state.isDobOnchanged
                                  ? action.validateField(
                                    value: state.dobController.text,
                                    fieldName: Strings.registerFormDobLabel,
                                    isDob: true,
                                  )
                                  : null,
                          hintText: Strings.registerFormDobPlaceHolder,
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
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary, 
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
                                      .primary, 
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
                                      .error, ),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_month_outlined,
                            size: 22,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: Strings.registerFormAgeLabel,
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
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
                      const SizedBox(height: 6),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color:
                                !state.isRegistering
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.secondary.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            state.age == null
                                ? Strings.registerFormAgePlaceHolder
                                : '${state.age}',
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: Strings.registerFormGenderLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text:  Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField(
                value: state.selectedGender,
                hint: Text(
                  Strings.registerFormGenderPlaceHolder,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onChanged:
                    state.isRegistering
                        ? null
                        : (String? newValue) {
                          action.updateSelectedGender(newValue);
                          action.updateIsSelectedGenderOnchanged(false);
                          bool isValid =
                              action.validateField(
                                value: newValue,
                                fieldName: Strings.registerFormGenderLabel,
                                isGender: true,
                              ) ==
                              null;
                          action.updateIsSelectedGenderValidate(isValid);
                        },
                items:
                    state.genders.map((String gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          gender,
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                decoration: InputDecoration(
                  errorText:
                      state.isSelectedGenderOnchanged
                          ? action.validateField(
                            value: state.selectedGender,
                            fieldName: Strings.registerFormGenderLabel,
                            isGender: true,
                          )
                          : null,
                  contentPadding: const EdgeInsets.all(12),
                  isDense: true,
                  errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color:
                          state.isRegistering
                              ? Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.2)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary, 
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color:
                          !state.isRegistering
                              ? Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.2)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary, 
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: Strings.registerFormReferrenceLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: ' ${Strings.optnltxt}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.6,
              ),
              enabled: !state.isRegistering,
              controller: state.referredController,
              decoration: InputDecoration(
                hintText: Strings.registerFormReferrencePlaceHolder,
                contentPadding: const EdgeInsets.all(14),
                isDense: true,
                errorStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              buttonText:
                  state.isRegistering
                      ? Strings.regingBtnText
                      : Strings.regBtnText,
              isLoading: state.isRegistering,
              onPressed: () {
                action.handleRegister(context, authState.userDetails![ApiKeyEnum.doctorId.key].toString() , widget.date, widget.time!);
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed:
                    state.isRegistering
                        ? () {}
                        : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => RegisteredUserFormView(
                                    date: widget.date,
                                    timeSlot: widget.time!,
                                  ),
                            ),
                          );
                          action.clearfields();
                        },
                child: Text(
Strings.registerFormAlredyRegBtnText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
