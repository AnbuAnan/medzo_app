import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';
import 'package:medzo/viewModel/new_appointment_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:medzo/widgets/file_input.dart';
import 'package:medzo/widgets/gradient_button.dart';
import 'package:medzo/widgets/uploaded_file.dart';

class NewAppointmentFormView extends ConsumerStatefulWidget {
  const NewAppointmentFormView(
      {super.key,
      required this.patientId,
      required this.date,
      required this.time});

  final int patientId;
  final DateTime date;
  final TimeSlot time;

  @override
  NewAppointmentFormViewState createState() => NewAppointmentFormViewState();
}

class NewAppointmentFormViewState
    extends ConsumerState<NewAppointmentFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(newAppointmentViewModelProvider);
    var action = ref.read(newAppointmentViewModelProvider.notifier);
    var authState = ref.watch(authProvider);
    var homeAction = ref.read(homeViewModelProvider.notifier);
    var myScheduleAction = ref.read(myScheduleViewModelProvider.notifier);
    var scheduleListAction = ref.read(scheduleListViewModelProvider.notifier);

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
          Strings.newAptAppBarText,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
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
                Strings.newAptPatientIDLabel,
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: Strings.newAptChiefComplaintLabel,
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
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) {
                          action.updateIsCheifComplaintValidated(false);
                        },
                        enabled: !state.isProcessing,
                        controller: state.cheifComplaintController,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                        maxLines: 5,
                        decoration: InputDecoration(
                          errorText: state.isCheifComplaintValidated
                              ? action.validateCheifComplaint(
                                  state.cheifComplaintController.text)
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400),
                          hintText: Strings.newAptChiefComplaintPlaceHolder,
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.error,
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
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.newAptDateLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: !state.isProcessing
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            size: 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.newAptTimeLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: !state.isProcessing
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${widget.time.startTime.format(context)} - ${widget.time.endTime.format(context)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          Icon(
                                            Icons.access_time_outlined,
                                            size: 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
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
                      Text(Strings.newAptPersonalHistoryRadioBtnLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w400)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                toggleable: false,
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: Strings.newAptYesOptionValue,
                                groupValue: state.selectedPersonalHistoryRadio,
                                onChanged: state.isProcessing
                                    ? null
                                    : (value) {
                                        action
                                            .updateSelectedPersonalHistoryRadio(
                                                value as String);
                                      },
                              ),
                              Text(Strings.newAptYesLabel,
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
                                toggleable: false,
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: Strings.newAptNoOptionValue,
                                groupValue: state.selectedPersonalHistoryRadio,
                                onChanged: state.isProcessing
                                    ? null
                                    : (value) {
                                        action
                                            .updateSelectedPersonalHistoryRadio(
                                                value as String);
                                      },
                              ),
                              Text(Strings.newAptNoLabel,
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
                        children: Strings.personalHistoryDiceaseList
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
                          hintText: Strings.newAptTextAreaHint,
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
                      RichText(
                        text: TextSpan(
                          text: Strings.newAptPastHistoryLabel,
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
                      if (state.isPastHistoryInvalid)
                        Column(
                          children: [
                            Text(
                              Strings.newAptPastHistoryErrMsg,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: Strings.pastHistoryDiceaseList
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
                                  action.updateIsPastHistoryInvalid(false);
                                  action.handleSelectedPastHistoryCheckbox(
                                      value!, title);
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: !state.isProcessing,
                        controller: state.pastHistoryController,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          hintText: Strings.newAptTextAreaHint,
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
                      RichText(
                        text: TextSpan(
                          text: Strings.newAptAppointmentTypeLabel,
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
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                        value: state.selectedAppointmentType,
                        hint: Text(
                          Strings.newAptAppointmentTypePlaceHolder,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400),
                        ),
                        items: Strings.newAptAppointmentTypeOptions
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: state.isProcessing
                            ? null
                            : (newValue) {
                                action.updateSelectedAppointmentType(newValue!);
                                action.updateIsAptTypeValidated(false);
                              },
                        decoration: InputDecoration(
                          errorText: state.isAptTypeValidated
                              ? action.validateAptType(
                                  state.selectedAppointmentType)
                              : null,
                          hintText: Strings.newAptAppointmentTypePlaceHolder,
                          contentPadding: const EdgeInsets.all(12),
                          isDense: true,
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w400),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: state.isProcessing
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: state.isProcessing
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.2)
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary, 
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error, 
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
                          text: Strings.newAptReportLabel,
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
                                    .copyWith(fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          FileInput(
                            icon: Icons.file_upload_outlined,
                            text: Strings.uploadFileBtnText,
                            pickFile: state.isProcessing
                                ? null
                                : action.updateSelectedReportFile,
                          ),
                          const SizedBox(width: 12),
                          FileInput(
                              icon: Icons.document_scanner,
                              text: Strings.newAptScanFileLabel,
                              pickFile: state.isProcessing
                                  ? null
                                  : action.updateSelectedReportFile),
                        ],
                      ),
                      if (state.selectedReportFile != null)
                        UploadedFileDisplay(
                          isEditMode: false,
                            file: state.selectedReportFile!,
                            onDelete: state.isProcessing
                                ? null
                                : () {
                                    action.updateSelectedReportFile(null);
                                  }),
                      const SizedBox(height: 24),
                      GradientButton(
                          buttonText: state.isProcessing
                              ? Strings.bookingBtnText
                              : Strings.bookAptBtnText,
                          isLoading: state.isProcessing,
                          onPressed: () {
                            if(!state.reportFileMax){

                            action.handleBookAppointment(
                              context,
                              widget.patientId,
                              widget.time,
                              widget.date,
                              authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                              homeAction.fetchAppointments,
                              myScheduleAction.getSlotDetails,
                              scheduleListAction.fetchSlotDetails,
                            );
                            }
                          }),
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