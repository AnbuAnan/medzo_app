import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/patient_profile_view.dart';
import 'package:medzo/viewModel/edit_patient_past_history_view_model.dart';
import 'package:medzo/viewModel/patient_profile_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class EditPatientPastHistoryView extends ConsumerStatefulWidget {
  const EditPatientPastHistoryView(
      {super.key,
      required this.patientId,
      required this.patientName,
      required this.pastHistoryData});

  final int patientId;
  final String patientName;

  final Map<String, dynamic> pastHistoryData;

  @override
  EditPatientPastHistoryViewState createState() =>
      EditPatientPastHistoryViewState();
}

class EditPatientPastHistoryViewState
    extends ConsumerState<EditPatientPastHistoryView> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.watch(editPatientPastHistoryViewModelProvider.notifier);

      action.populateFields(widget.pastHistoryData);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(editPatientPastHistoryViewModelProvider);
    var action = ref.read(editPatientPastHistoryViewModelProvider.notifier);
    var patientprofileAction =
        ref.read(patientProfileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) {
              return route.settings.name == PatientProfileViewState.routeName;
            });
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
          ),
        ),
        title: Text(
          Strings.editNewAptAppBarText,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.editNewAptPatientIDLabel,
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          text: Strings.editNewAptPastHistoryLabel,
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
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: Strings.editPastHistoryDiceaseList
                            .map(
                              (title) => CheckboxListTile(
                                enabled: !state.isProcessing,
                                contentPadding: const EdgeInsets.all(0),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                title: Text(title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w400)),
                                value: state.selectedPastHistoryCheckbox
                                    .contains(title),
                                onChanged: (bool? value) {
                                  action.handleSelectedPastHistoryCheckbox(
                                      value!, title);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            )
                            .toList(),
                      ),
                      if (state.isPastHistoryInvalid)
                        Column(
                          children: [
                            Text(
                              Strings.editNewAptPastHistoryErrMsg,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: state.pastHistoryController,
                        enabled: !state.isProcessing,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          hintText: Strings.editNewAptTextAreaHint,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Strings.newAptPersonalHistoryLabel,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.editNewAptPersonalHistoryRadioBtnLabel,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                toggleable: false,
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: Strings.yesText,
                                groupValue: state.selectedPersonalHistoryRadio,
                                onChanged: state.isProcessing
                                    ? null
                                    : (value) {
                                        action
                                            .updateSelectedPersonalHistoryRadio(
                                                value as String);
                                      },
                              ),
                              Text(Strings.editNewAptYesLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Radio(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: Strings.noText,
                                groupValue: state.selectedPersonalHistoryRadio,
                                onChanged: state.isProcessing
                                    ? null
                                    : (value) {
                                        action
                                            .updateSelectedPersonalHistoryRadio(
                                                value as String);
                                      },
                              ),
                              Text(Strings.editNewAptNoLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: Strings.editPersonalHistoryDiceaseList
                            .map((title) => CheckboxListTile(
                                  enabled: !state.isProcessing,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  title: Text(title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400)),
                                  value: state.selectedPersonalHistoryCheckbox
                                      .contains(title),
                                  onChanged: (bool? value) {
                                    action
                                        .handleSelectedPersonalHistoryCheckbox(
                                            value!, title);
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: !state.isProcessing,
                        controller: state.personalHistoryController,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          hintText: Strings.editNewAptTextAreaHint,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        isLoading: state.isProcessing,
                        buttonText: state.isProcessing
                            ? Strings.updatingBtnText
                            : Strings.updateBtnText,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            action.handleBookAppointment(
                                context,
                                widget.patientId,
                                widget.patientName,
                                widget.pastHistoryData,
                                patientprofileAction.fetchPastHistoryInfo);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
