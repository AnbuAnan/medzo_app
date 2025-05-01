import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/existing_appointment_form_view.dart';
import 'package:medzo/view/register_form_view.dart';
import 'package:medzo/viewModel/appointment_view_model.dart';
import 'package:medzo/viewModel/existing_appointment_view_model.dart';
import 'package:medzo/viewModel/register_form_view_model.dart';

class AppointmentView extends ConsumerStatefulWidget {
  const AppointmentView({
    super.key,
    required this.date,
    this.time,
    this.availTimeSlots,
    this.followupName,
    this.followupId,
    this.followupAppointmentId,
    this.reScheduleName,
    this.reScheduleId,
    this.reScheduleAppointmentId,
    this.outDatedName,
    this.outDatedId,
    this.outDatedAppointmentId,
    required this.formType,
  });

  final DateTime date;
  final TimeSlot? time;
  final List<TimeSlot>? availTimeSlots;
  final String? followupName;
  final int? followupId;
  final int? followupAppointmentId;
  final String? reScheduleName;
  final int? reScheduleId;
  final int? reScheduleAppointmentId;
  final String? outDatedName;
  final int? outDatedId;
  final int? outDatedAppointmentId;
  final String formType;

  @override
  AppointmentViewState createState() => AppointmentViewState();
}

class AppointmentViewState extends ConsumerState<AppointmentView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(appointmentViewModelProvider.notifier);
      action.updateFormType(widget.formType);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(appointmentViewModelProvider);
    var action = ref.read(appointmentViewModelProvider.notifier);

    var actionExistingForm = ref.read(
      existingAppointmentViewModelProvider.notifier,
    );
    var actionNewAptForm = ref.read(
      existingAppointmentViewModelProvider.notifier,
    );
    var actionregisterForm = ref.read(registerFormViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (state.formType == Strings.appointmentFormTypeExisting) {
              if (mounted) {
                actionExistingForm.clearFields();
              }
            } else {
              if (mounted) {
                actionNewAptForm.clearFields();
                actionregisterForm.clearfields();
              }
            }
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          widget.followupId != null
              ? Strings.appointmentFormTitleFollowup
              : widget.reScheduleId != null
              ? Strings.appointmentFormTitleReSchedule
              : state.formType == Strings.appointmentFormTypeExisting
              ? Strings.existingFormAppBarText
              : Strings.newFormAppBarText,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.appointmentFormTypeText,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Center the row
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: Strings.appointmentFormTypeNew,
                        groupValue: state.formType,
                        onChanged: (value) {
                          widget.formType != Strings.appointmentFormTypeExisting
                              ? action.updateFormType(value!)
                              : null;
                        },
                      ),
                      Text(
                        Strings.appointmentFormTypeNew,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // Space between the radio buttons
                  Row(
                    children: [
                      Radio(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: Strings.appointmentFormTypeExisting,
                        groupValue: state.formType,
                        onChanged: (value) {
                          action.updateFormType(value!);
                        },
                      ),
                      Text(
                        Strings.appointmentFormTypeExisting,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              state.formType == Strings.appointmentFormTypeExisting
                  ? ExistingAppointmentFormView(
                    date:
                        widget.reScheduleId != null || widget.outDatedId != null
                            ? DateTime.now()
                            : widget.date,
                    time: widget.time,
                    followupAvilableSlot: widget.availTimeSlots ?? [],
                    followupPatientId: widget.followupId,
                    followupAppointmentId: widget.followupAppointmentId,
                    followupPatientName: widget.followupName,
                    outDatedId: widget.outDatedId,
                    outDatedAppointmentId: widget.outDatedAppointmentId,
                    outDatedName: widget.outDatedName,
                    rescheduleName: widget.reScheduleName,
                    rescheduleId: widget.reScheduleId,
                    rescheduleAppointmentId: widget.reScheduleAppointmentId,
                  )
                  : RegisterFormView(date: widget.date, time: widget.time),
            ],
          ),
        ),
      ),
    );
  }
}
