import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/existing_appointment_view_model.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:medzo/widgets/file_input.dart';
import 'package:medzo/widgets/gradient_button.dart';
import 'package:medzo/widgets/uploaded_file.dart';
import 'package:searchfield/searchfield.dart';

class ExistingAppointmentFormView extends ConsumerStatefulWidget {
  const ExistingAppointmentFormView({
    super.key,
    required this.date,
    this.time,
    this.followupPatientName,
    this.followupPatientId,
    this.followupAppointmentId,
    this.followupAvilableSlot,
    this.rescheduleName,
    this.rescheduleId,
    this.rescheduleAppointmentId,
    this.outDatedName,
    this.outDatedId,
    this.outDatedAppointmentId,
  });

  final DateTime date;
  final TimeSlot? time;
  final String? followupPatientName;
  final int? followupPatientId;
  final int? followupAppointmentId;
  final List<TimeSlot>? followupAvilableSlot;
  final String? rescheduleName;
  final int? rescheduleId;
  final int? rescheduleAppointmentId;
  final String? outDatedName;
  final int? outDatedId;
  final int? outDatedAppointmentId;

  @override
  ExistingAppointmentFormViewState createState() =>
      ExistingAppointmentFormViewState();
}

class ExistingAppointmentFormViewState
    extends ConsumerState<ExistingAppointmentFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(existingAppointmentViewModelProvider.notifier);
      var authState = ref.read(authProvider);

      action.updatePatientOrCaseIdOptions([]);
      action.updateselecteddate(widget.date);
      action.getAvailableSlotsDetails(context,authState.userDetails![ApiKeyEnum.doctorId.key].toString());
      action.updateDobController();
      if (widget.rescheduleAppointmentId != null) {
        action.getRescheduleAptDetails(
          context,
          authState.userDetails![ApiKeyEnum.doctorId.key],
          widget.rescheduleAppointmentId!,
        );
      }
      if (widget.outDatedAppointmentId != null) {
        action.getRescheduleAptDetails(
          context,
          authState.userDetails![ApiKeyEnum.doctorId.key],
          widget.outDatedAppointmentId!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(existingAppointmentViewModelProvider);
    var action = ref.read(existingAppointmentViewModelProvider.notifier);
    var homeAction = ref.read(homeViewModelProvider.notifier);
    var myScheduleAction = ref.read(myScheduleViewModelProvider.notifier);
    var scheduleListAction = ref.read(scheduleListViewModelProvider.notifier);
    var authState = ref.watch(authProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if(widget.followupPatientId != null && widget.followupAppointmentId != null || widget.rescheduleId != null &&widget.rescheduleAppointmentId != null ) ...[
            // Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //                 color: Theme.of(context)
            //                     .colorScheme
            //                     .primaryContainer
            //                     .withOpacity(0.5),
            //                 borderRadius: BorderRadius.circular(12)),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Row(
            //                   children: [
            //                     Container(
            //                       width: 45,
            //                       height: 45,
            //                       decoration: BoxDecoration(
            //                         shape: BoxShape.circle,
            //                         image: DecorationImage(
            //                             fit: BoxFit.cover,
            //                             image:
            //                                 AssetImage(Images.patientProfile)),
            //                       ),
            //                     ),
            //                     const SizedBox(width: 8),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(widget.followupPatientName ?? widget.rescheduleName!,
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .titleLarge!
            //                                 .copyWith(
            //                                     fontWeight: FontWeight.w500)),
            //                         const SizedBox(height: 4),
            //                         Text(
            //                             'Case ID: ${widget.followupAppointmentId ?? widget.rescheduleAppointmentId}'),
            //                         RichText(
            //                           text: TextSpan(
            //                             text: 'Ph No: ',
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .labelSmall!
            //                                 .copyWith(
            //                                     fontWeight: FontWeight.w400),
            //                             children: [
            //                               TextSpan(
            //                                 text: '+91 9876543210',
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .labelSmall!
            //                                     .copyWith(
            //                                         color: Theme.of(context)
            //                                             .colorScheme
            //                                             .primary),
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //                 IconButton(
            //                     onPressed: () {
            //                       action.launchPhoneCall(context, "9876543210");
            //                     },
            //                     icon: Icon(
            //                       Icons.phone_in_talk_rounded,
            //                       color: Theme.of(context).colorScheme.primary,
            //                     ))
            //               ],
            //             ),
            //           )]else if(widget.followupPatientId == null && widget.outDatedId == null && widget.rescheduleId == null)...[
                        RichText(
              text: TextSpan(
                text: Strings.extAptPatientIDLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            //Followup
            widget.followupPatientId == null &&
                    widget.rescheduleId == null &&
                    widget.outDatedId == null
                ? SearchField<String>(
                  enabled: !state.isBooking,
                  controller: state.searchFieldController,
                  suggestions:
                      state.searchFieldController.text.contains(Strings.forwardSlashSymbol)
                          ? []
                          : state.displayedOptions.isEmpty &&
                              state.searchFieldController.text.isNotEmpty
                          ? [
                            SearchFieldListItem<String>(
                              Strings.noSearchFound,
                              child: Text(
                              Strings.noSearchFound,
                                
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ]
                          : state.displayedOptions.map((option) {
                            return SearchFieldListItem<String>(
                              option,
                              item: option,
                            );
                          }).toList(),
                  onSearchTextChanged: (query) {
                    action.onSearchTextChanged(query, context);
                    return null;
                  },
                  hint: Strings.extAptPatientIDSearchFieldPlaceHolder ,
                  searchInputDecoration: SearchInputDecoration(
                    searchStyle: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w400,
                    ),
                    errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            state.isBooking
                                ? Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.2)
                                : Theme.of(context).colorScheme.primary,
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            state.isBooking
                                ? Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.2)
                                : Theme.of(context)
                                    .colorScheme
                                    .primary, 
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    hintText: Strings.extAptPatientIDPlaceHolder,
                    hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  suggestionsDecoration: SuggestionDecoration(
                    color: Colors.transparent,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suggestionStyle: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
                  suggestionItemDecoration:
                      state.displayedOptions.isEmpty
                          ? null
                          : BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.extAptPatientIDSearchFieldErrMsg1;
                    }

                    if (!state.isItemSelected) {
                      return Strings.extAptPatientIDSearchFieldErrMsg2;
                    }

                    return null;
                  },
                  onSubmit: (value) {
                    String trimmedValue = value.trim();
                    bool isValidSuggestion = state.displayedOptions.any(
                      (option) =>
                          option.trim().toLowerCase() ==
                          trimmedValue.toLowerCase(),
                    );

                    if (isValidSuggestion) {
                      action.updateisItemSelected(true);
                      action.onSuggestionTap(trimmedValue);
                    } else {
                      state.searchFieldController.clear();
                      action.updateisItemSelected(false);
                    }
                  },
                  onSuggestionTap: (SearchFieldListItem<String> suggestion) {
                    action.updateisItemSelected(true);

                    state.searchFieldController.text = suggestion.item!;
                    action.onSuggestionTap(suggestion.item);
                    FocusScope.of(
                      context,
                    ).unfocus(); 
                  },

                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                    if (!state.isItemSelected) {
                      state.searchFieldController.clear();
                      setState(() {
                        state.displayedOptions.clear(); 
                      });
                    }
                  },

                  onSaved: (value) {
                    if (value == null ||
                        !state.displayedOptions.contains(value)) {
                      state.searchFieldController.clear();
                    }
                  },
                )
                : SizedBox(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color:
                            state.isBooking
                                ? Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.2)
                                : Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.followupPatientId != null
                            ? '${widget.followupPatientName!}/${widget.followupPatientId!}'
                            : widget.rescheduleId != null
                            ? '${widget.rescheduleName!}/${widget.rescheduleId!}'
                            : '${widget.outDatedName!}/${widget.outDatedId!}',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.extAptDateLabel,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        child:
                            widget.rescheduleAppointmentId != null ||
                                    widget.outDatedId != null
                                ? TextFormField(
                                  enabled: !state.isBooking,
                                  readOnly: true,
                                  style: Theme.of(context).textTheme.labelSmall!
                                      .copyWith(fontWeight: FontWeight.w400),
                                  controller: state.dateController,
                                  onTap: () {
                                    action.selectDate(context,authState.userDetails![ApiKeyEnum.doctorId.key].toString());
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        state.selectedDate == null
                                            ? Strings.extAptDateHint
                                            : "${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}",
                                    contentPadding: const EdgeInsets.all(14),
                                    isDense: true,
                                    errorStyle: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    hintStyle: Theme.of(
                                      context,
                                    ).textTheme.labelSmall!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
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
                                                .error, 
                                      ),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.calendar_month_outlined,
                                      size: 22,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return Strings.extAptDateErrText;
                                    }
                                    return null;
                                  },
                                )
                                : Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          state.isBooking
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.2)
                                              : Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                    ),
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
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 22,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                      ),
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
                        Strings.extAptTimeLabel,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        child:
                            widget.rescheduleId == null &&
                                    widget.followupPatientId == null &&
                                    widget.outDatedId == null
                                ? Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          state.isBooking
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.2)
                                              : Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.time != null
                                              ? '${widget.time!.startTime.format(context)} - ${widget.time!.endTime.format(context)}'
                                              : Strings.errorTextUpperCase,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Icon(
                                          Icons.access_time_outlined,
                                          size: 22,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : DropdownButtonFormField<TimeSlot>(
                                  items:
                                      _buildDropdownItems(), 
                                  onChanged:
                                      state.isBooking
                                          ? null
                                          : (TimeSlot? value) {
                                            action
                                                .updateIsSelectedFollowUpTimeSlot(
                                                  value,
                                                );
                                          },
                                  hint: Text(
                                    widget.followupPatientId != null
                                        ? (widget.followupAvilableSlot?.isNotEmpty ??
                                                false)
                                            ? Strings.extAptSelectTimeSlothint
                                            : Strings.extAptNoTimeSlothint
                                        : (state.availableSlots?.isNotEmpty ??
                                            false)
                                        ? Strings.extAptSelectTimeSlothint
                                        : Strings.extAptNoTimeSlothint,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                    errorStyle: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            state.isBooking
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.2)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary, 
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            state.isBooking
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.2)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary, 
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.labelSmall,
                                  validator: (value) {
                                    if (value == null) {
                                      return Strings.extAptTimeErrText;
                                    }
                                    return null;
                                  },
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
                text: Strings.newAptChiefComplaintLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: !state.isBooking,
              controller: state.cheifComplaintController,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
              maxLines: 5, 
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
                hintText: Strings.newAptChiefComplaintPlaceHolder,
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Strings.extAptChiefComplaintErrMsg1;
                }
                if (value.length < 5) {
                  return Strings.extAptChiefComplaintErrMsg2;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: Strings.newAptAppointmentTypeLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text:Strings.mandatorySymbol,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
              value: state.selectedAppointmentType,
              hint: Text(
                Strings.extAptAppointmentTypePlaceHolder,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items:
                  Strings.newAptAppointmentTypeOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged:
                  state.isBooking
                      ? null
                      : (newValue) {
                        action.updateSelectedAppointmentType(newValue);
                      },
              validator:
                  (value) =>
                      value == null
                          ? Strings.extAptAppointmentTypeErrMsg
                          : null,
              decoration: InputDecoration(
                hintText: Strings.extAptAppointmentTypePlaceHolder,
                contentPadding: const EdgeInsets.all(12),
                isDense: true,
                errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        state.isBooking
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
                        state.isBooking
                            ? Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.2)
                            : Theme.of(context)
                                .colorScheme
                                .primary, 
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.error, 
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

            Text(
              Strings.newAptReportLabel,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FileInput(
                  icon: Icons.file_upload_outlined,
                  text: Strings.uploadFileBtnText,
                  pickFile: action.updateSelectedReportFile,
                ),
                const SizedBox(width: 12),
                FileInput(
                  icon: Icons.document_scanner,
                  text: Strings.addAptScanFileLabel,
                  pickFile: action.updateSelectedReportFile,
                ),
              ],
            ),
            if (state.selectedReportFile != null)
              UploadedFileDisplay(
                isEditMode: false,
                file: state.selectedReportFile!,
                onDelete: () {
                  action.updateSelectedReportFile(null);
                },
              ),
            const SizedBox(height: 24),
            GradientButton(
              buttonText: state.isBooking ? Strings.bookingBtnText : Strings.bookAptBtnText,
              isLoading: state.isBooking,
              onPressed: () {
                if (formKey.currentState!.validate() && !state.reportFileMax) {
                  action.handleBookAppointment(
                    context,
                    widget.date,
                    widget.followupPatientId == null &&
                            widget.rescheduleId == null &&
                            widget.outDatedId == null
                        ? widget.time!
                        : state.isSelectedFollowupTimeSlot!,
                    widget.followupPatientId,
                    widget.followupAppointmentId,
                    widget.outDatedId,
                    widget.outDatedAppointmentId,
                    widget.rescheduleId,
                    widget.rescheduleAppointmentId,
                    authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                    homeAction.fetchAppointments,
                    myScheduleAction.getSlotDetails,
                    scheduleListAction.fetchSlotDetails,
                    scheduleListAction.fetchFollowups,
                    scheduleListAction.fetchOutdatedList,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<TimeSlot>> _buildDropdownItems() {
    var state = ref.watch(existingAppointmentViewModelProvider);

    final slots =
        widget.followupPatientId != null
            ? widget.followupAvilableSlot
            : state.availableSlots;

    if (slots == null || slots.isEmpty) {
      return [];
    }

    return slots.map((slot) {
      return DropdownMenuItem(
        value: slot,
        child: Text(
          "${slot.startTime.format(context)} - ${slot.endTime.format(context)}",
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(color: Colors.black87),
        ),
      );
    }).toList();
  }
}
