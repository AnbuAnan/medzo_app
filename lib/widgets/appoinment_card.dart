// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/patient_profile_view.dart';
import 'package:medzo/view/precheck_view.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/widgets/precheckDialog.dart';

class AppoinmentCard extends ConsumerStatefulWidget {
  const AppoinmentCard({
    super.key,
    required this.name,
    required this.caseId,
    required this.startTime,
    required this.endTime,
    required this.appointmentId,
    required this.patientStatus,
    required this.date,
    required this.lifeCycleStatus,
    required this.cheifComplaint,
  });

  final String name;
  final int caseId;
  final int? appointmentId;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String patientStatus;
  final DateTime date;
  final String lifeCycleStatus;
  final String cheifComplaint;

  @override
  AppoinmentCardState createState() => AppoinmentCardState();
}

class AppoinmentCardState extends ConsumerState<AppoinmentCard> {
  @override
  Widget build(BuildContext context) {
    var action = ref.watch(homeViewModelProvider.notifier);
    return Card(
      color:
          widget.patientStatus == Strings.aptCradAptNewTypeText
              ? Theme.of(context).colorScheme.onTertiary
              : Theme.of(context).colorScheme.primaryFixedDim,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(Images.patientProfile),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${Strings.caseIDLabelText}${widget.caseId}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder:
                                (context) => PatientProfileView(
                                  patientName: widget.name,
                                  patientID: widget.caseId,
                                ),
                            settings: const RouteSettings(
                              name: PatientProfileViewState.routeName,
                            ),
                          ),
                        )
                        .then((_) => {action.fetchAppointments(context)});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: Text(
                      Strings.aptCardViewRptText,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: Theme.of(context).colorScheme.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.startTime.format(context)} - ${widget.endTime.format(context)}',
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                //precheck button
                GestureDetector(
                  onTap: () async {
                    if (widget.date
                            .toLocal()
                            .difference(DateTime.now().toLocal())
                            .inDays ==
                        0) {
                      if (widget.lifeCycleStatus == ApiKeyEnum.appointmenCreated.key) {
                        debugPrint(widget.cheifComplaint);
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (context) => PrecheckView(
                                      chiefComplaint: widget.cheifComplaint,
                                      patientId: widget.caseId,
                                      patientName: widget.name,
                                      appointmentId: widget.appointmentId!,
                                      isEdit: false,
                                    ),
                              ),
                            )
                            .then((result) {
                              if (result == true) {
                                action.getAppointmentsOfSelectedDate(context);
                              }
                            });
                      } else if (widget.lifeCycleStatus ==
                          ApiKeyEnum.precheckCompleted.key) {
                        debugPrint(widget.cheifComplaint);
                        showDialog(
                          context: context,
                          builder:
                              (context) => PrecheckDialog(
                                context: context,
                                patientName: widget.name,
                                patientId: widget.caseId,
                                chiefComplaint:
                                    widget
                                        .cheifComplaint, 
                                date: DateTime.now(),
                                appointmentId: widget.appointmentId,
                              ),
                        );
                      }
                    } else {
                      null;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          widget.date
                                      .toLocal()
                                      .difference(DateTime.now().toLocal())
                                      .inDays ==
                                  0
                              ? Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.4)
                              : Theme.of(
                                context,
                              ).colorScheme.secondaryFixed.withOpacity(0.6),
                    ),
                    child: Text(
                      Strings.aptCradPrecheckText,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            widget.date
                                        .toLocal()
                                        .difference(DateTime.now().toLocal())
                                        .inDays ==
                                    0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
