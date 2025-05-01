import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/edit_patient_details_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class EditPatientDetailsView extends ConsumerStatefulWidget {
  const EditPatientDetailsView(
      {super.key,
      required this.patientId,
      required this.personalData,
      required this.pastHistoryData});

  final int patientId;
  final Map<String, dynamic> personalData;
  final Map<String, dynamic> pastHistoryData;

  @override
  EditPatientDetailsViewState createState() => EditPatientDetailsViewState();
}

class EditPatientDetailsViewState
    extends ConsumerState<EditPatientDetailsView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.watch(editPatientDetailsViewModelProvider.notifier);

      action.populateFields(widget.personalData);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(editPatientDetailsViewModelProvider);
    var action = ref.read(editPatientDetailsViewModelProvider.notifier);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
          ),
        ),
        title: Text(
          Strings.editRegisterFormAppBarText,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.editRegisterFormPatientIDLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryFixed
                      .withOpacity(0.3),
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.patientId.toString(),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: Strings.editRegisterFormAadharLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text: Strings.mandatorySymbol,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.6),
                            enabled: !state.isRegistering,
                            controller: state.aadharController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: Strings.editRegisterFormAadharPlaceHolder,
                              contentPadding: const EdgeInsets.all(14),
                              isDense: true,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, 
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, 
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error, 
                                ),
                              ),
                            ),
                            
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              text: Strings.editRegisterFormNameLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text: Strings.mandatorySymbol,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.6),
                            controller: state.nameController,
                            enabled: !state.isRegistering,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: Strings.editRegisterFormNamePlaceHolder,
                              contentPadding: const EdgeInsets.all(14),
                              isDense: true,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, 
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error, 
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return Strings.editRegisterFormNameIsRewuiredErrMsg;
                              }
                              if (RegExp(r'\d').hasMatch(value)) {
                                return Strings.editRegisterFormNameNotAllowErrMsg;
                              }
                              if (value.length < 3) {
                                return Strings.editRegisterFormNamelenthErrMsg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              text: Strings.editRegisterFormMobileNumberLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text: Strings.mandatorySymbol,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.6),
                            controller: state.phController,
                            enabled: !state.isRegistering,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText:
                                  Strings.editRegisterFormMobileNumberPlaceHolder,
                              contentPadding: const EdgeInsets.all(14),
                              isDense: true,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,  
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, 
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error, 
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return Strings.editRegisterFormPhoneIsrequiredErrMsg;
                              }
                              if (value.length != 10) {
                                return Strings.editRegisterFormPhoneNoLenthErrMsg;
                              }
                              return null;
                            },
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
                                        text: Strings.editRegisterFormDobLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                        children: [
                                          TextSpan(
                                            text: Strings.mandatorySymbol,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.6),
                                        readOnly: true,
                                        enabled: !state.isRegistering,
                                        controller: state.dobController,
                                        onTap: () {
                                          action.selectDOB(context);
                                        },
                                        decoration: InputDecoration(
                                          hintText: Strings
                                              .editRegisterFormDobPlaceHolder,
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          isDense: true,
                                          errorStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                fontWeight: FontWeight.w400,
                                              ),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontWeight: FontWeight.w400,
                                              ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary, 
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary, 
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error, 
                                            ),
                                          ),
                                          suffixIcon: const Icon(
                                            Icons.calendar_month_outlined,
                                            size: 22,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return Strings.editRegisterFormDobErrMsg;
                                          }
                                          return null;
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 12), 
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: Strings.editRegisterFormAgeLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                        children: [
                                          TextSpan(
                                            text: Strings.mandatorySymbol,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
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
                                            color: !state.isRegistering
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondaryFixed),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          state.age == null
                                              ? Strings
                                                  .editRegisterFormAgePlaceHolder
                                              : '${state.age}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
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
                              text: Strings.editRegisterFormGenderLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text: Strings.mandatorySymbol,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
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
                                Strings.editRegisterFormGenderPlaceHolder,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w400),
                              ),
                              onChanged: (String? newValue) {
                                action.updateSelectedGender(newValue);
                              },
                              items: state.genders.map((String gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    gender,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12),
                                isDense: true,
                                errorStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.w400,
                                    ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  borderSide: BorderSide(
                                    color: state.isRegistering
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2)
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary, 
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  borderSide: BorderSide(
                                    color: state.isRegistering
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.2)
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary, 
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return Strings.editRegisterFormGenderErrMsg;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              text: Strings.editRegisterFormReferrenceLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                    text: ' ${Strings.optnltxt}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.6),
                            controller: state.referredController,
                            enabled: !state.isRegistering,
                            decoration: InputDecoration(
                              hintText: Strings.assistantFormNameHind,
                              contentPadding: const EdgeInsets.all(14),
                              isDense: true,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w400,
                                  ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, 
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error, 
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GradientButton(
                            isLoading: state.isRegistering,
                            buttonText: state.isRegistering
                                ? Strings.updatingBtnText
                                : Strings.updateBtnText,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                action.handleRegister(context, widget.patientId,authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                                    widget.pastHistoryData);
                              }
                            },
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
    );
  }
}
