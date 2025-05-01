import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/skeleton/schedule_list_skeleton.dart';
import 'package:medzo/view/appointment_view.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:medzo/widgets/calendar.dart';

class ScheduleListView extends ConsumerStatefulWidget {
  const ScheduleListView({super.key, this.reload});

  final bool? reload;

  @override
  ScheduleListViewState createState() => ScheduleListViewState();
}

class ScheduleListViewState extends ConsumerState<ScheduleListView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authState = ref.watch(authProvider);
      var action = ref.read(scheduleListViewModelProvider.notifier);
      action.initialize(
        context,
        authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
        widget.reload,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(scheduleListViewModelProvider);
    var authState = ref.watch(authProvider);
    var action = ref.read(scheduleListViewModelProvider.notifier);
    var homeAction = ref.read(homeViewModelProvider.notifier);
    var myScheduleAction = ref.read(myScheduleViewModelProvider.notifier);

    Widget content =
        state.isFetching
            ? const ScheduleListSkeleton()
            : (state.arrangedSlots.isNotEmpty ||
                state.followupList.isNotEmpty ||
                state.outdatedList.isNotEmpty)
            ? SingleChildScrollView(
              child: Column(
                children: [
                  if (state.followupList.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.scheduleListFollowupsTitle,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          ...state.followupList.map((followup) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 28,
                                right: 28,
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color:
                                    action.isPastDay(state.selectedDate)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryFixed
                                            .withOpacity(0.7)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiaryFixed
                                            .withOpacity(0.6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          Images.patientProfile,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        followup[ApiKeyEnum.patientName.key],
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge!,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${Strings.caseIDLabelText}${followup[ApiKeyEnum.patientId.key].toString()}',
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
                                    ],
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      action.onMenuOptionSelectedFollowup(
                                        value,
                                        context,
                                        followup,
                                      );
                                    },
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value:
                                                Strings
                                                    .scheduleListBookAptPopupMenuValue,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  Strings
                                                      .scheduleListBookAptText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value:
                                                Strings
                                                    .scheduleListFollowupsPopupMenuValue,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.watch,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  Strings
                                                      .scheduleListFollowupsText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (state.outdatedList.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.scheduleListOutdtedTitle,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          ...state.outdatedList.map((outdatedPatient) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 28,
                                right: 28,
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Theme.of(
                                  context,
                                ).colorScheme.onTertiaryFixed.withOpacity(0.6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          Images.patientProfile,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outdatedPatient[ApiKeyEnum
                                            .patientName
                                            .key],
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${Strings.caseIDLabelText}${outdatedPatient[ApiKeyEnum.patientId.key].toString()}',
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
                                    ],
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      
                                      action.onMenuOptionSelectedOutDated(
                                        value,
                                        context,
                                        outdatedPatient[ApiKeyEnum
                                            .patientName
                                            .key],
                                        outdatedPatient[ApiKeyEnum
                                            .patientId
                                            .key],
                                        outdatedPatient[ApiKeyEnum
                                            .appointmentTimeId
                                            .key],
                                        Strings.scheduleListOutdtedTextForMenu,
                                        homeAction.fetchAppointments,
                                        myScheduleAction.getSlotDetails,
                                        authState
                                            .userDetails![ApiKeyEnum
                                                .doctorId
                                                .key]
                                            .toString(),
                                      );
                                    },
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value:
                                                Strings
                                                    .scheduleListSchedulePopupMenuValue,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  Strings
                                                      .scheduleListScheduleText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value:
                                                Strings.deleteBtnPopupMenuValue,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  Strings.deleteBtnText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  if (state.followupList.isNotEmpty ||
                      state.outdatedList.isNotEmpty) ...[
                    const Divider(color: Colors.black26),
                    const SizedBox(height: 8),
                  ],
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${state.selectedDate.day} ${action.months[state.selectedDate.month - 1].substring(0, 3)} ${state.selectedDate.year}',
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${state.appointmentCounts} ${Strings.scheduleListAppointmentText}${state.appointmentCounts <= 1 ? Strings.emptySpace : Strings.sText}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...state.arrangedSlots.entries.map((entry) {
                        int availableSlotCount =
                            entry.value.where((slot) => !slot.isBooked).length;
                        Map formattedTime = action.convertTo12HourFormat(
                          entry.key,
                        );
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedTime[Strings.timeLabel],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(letterSpacing: 1),
                                    ),
                                    Text(
                                      formattedTime[Strings.periodLabel],
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
                                  ],
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onTertiary,
                                        ),
                                        child: Text(
                                          '${Strings.slotStatus} $availableSlotCount${Strings.forwardSlashSymbol}${entry.value.length}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...entry.value.map((slot) {
                                        bool isPastTime = action.isPastTime(
                                          slot.startTime,
                                        );
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap:
                                                  slot.isBooked || isPastTime
                                                      ? null
                                                      : () {
                                                        Navigator.of(
                                                          context,
                                                        ).push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => AppointmentView(
                                                                  date:
                                                                      state
                                                                          .selectedDate,
                                                                  time: slot,
                                                                  formType:
                                                                      Strings
                                                                          .appointmentFormTypeNew,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border:
                                                      isPastTime &&
                                                              !slot.isBooked
                                                          ? Border.all(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .secondary,
                                                          )
                                                          : !isPastTime &&
                                                              !slot.isBooked
                                                          ? Border.all(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                          )
                                                          : null,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(50),
                                                      ),
                                                  color:
                                                      slot.isBooked
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onTertiaryFixed
                                                              .withOpacity(0.6)
                                                          : isPastTime
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondaryFixed
                                                              .withOpacity(0.7)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primaryContainer
                                                              .withOpacity(0.5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 45,
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                Images
                                                                    .patientProfile,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              slot.isBooked
                                                                  ? slot
                                                                      .patientName!
                                                                  : isPastTime
                                                                  ? Strings
                                                                      .notAvailableText
                                                                  : Strings
                                                                      .booknowText,
                                                              style: Theme.of(
                                                                context,
                                                              ).textTheme.titleLarge!.copyWith(
                                                                color:
                                                                    isPastTime &&
                                                                            !slot.isBooked
                                                                        ? Theme.of(
                                                                          context,
                                                                        ).colorScheme.secondary
                                                                        : Theme.of(
                                                                          context,
                                                                        ).colorScheme.onSecondaryContainer,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Row(
                                                              children: [
                                                                if (!slot
                                                                    .isBooked) ...[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time_outlined,
                                                                    size: 18,
                                                                    color:
                                                                        Theme.of(
                                                                          context,
                                                                        ).colorScheme.secondary,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                ],
                                                                Text(
                                                                  slot.isBooked
                                                                      ? '${Strings.caseIDLabelText}${slot.patientId}'
                                                                      : '${slot.startTime.format(context)} ${Strings.hypenText} ${slot.endTime.format(context)}',
                                                                  style: Theme.of(
                                                                    context,
                                                                  ).textTheme.labelSmall!.copyWith(
                                                                    color:
                                                                        Theme.of(
                                                                          context,
                                                                        ).colorScheme.secondary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    if (slot.isBooked &&
                                                        !action.isPastDay(
                                                          state.selectedDate,
                                                        ))
                                                      PopupMenuButton<String>(
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                        ),
                                                        onSelected: (value) {
                                                          action.onMenuOptionSelected(
                                                            value,
                                                            context,
                                                            slot.patientName!,
                                                            slot.patientId!,
                                                            slot.appointmentId!,
                                                            Strings
                                                                .scheduleListAppointmentTextForMenu,
                                                            authState
                                                                .userDetails![ApiKeyEnum
                                                                    .doctorId
                                                                    .key]
                                                                .toString(),
                                                            homeAction
                                                                .fetchAppointments,
                                                            myScheduleAction
                                                                .getSlotDetails,
                                                          );
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                              PopupMenuItem(
                                                                value:
                                                                    Strings
                                                                        .rescheduleBtnPopupMenuValue,
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .schedule,
                                                                      size: 20,
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          ).colorScheme.primary,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      Strings
                                                                          .scheduleListRescheduleText,
                                                                      style: Theme.of(
                                                                        context,
                                                                      ).textTheme.labelMedium!.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              PopupMenuItem(
                                                                value:
                                                                    Strings
                                                                        .deleteBtnPopupMenuValue,
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 20,
                                                                      color:
                                                                          Theme.of(
                                                                            context,
                                                                          ).colorScheme.error,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      Strings
                                                                          .deleteBtnText,
                                                                      style: Theme.of(
                                                                        context,
                                                                      ).textTheme.labelMedium!.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
            )
            : Center(
              child: Text(
                Strings.noScheduleText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          Strings.scheduleListAppBarTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            (!state.isFetching && state.errorOccurs)
                ? ExceptionHandlingView(
                  errorText: state.errorText,
                  retryFunc: () {
                    action.getSelectedDateDetails(
                      context,
                      authState.userDetails![ApiKeyEnum.doctorId.key],
                    );
                  },
                )
                : Column(
                  children: [
                    const Calendar(),
                    const SizedBox(height: 24),
                    Expanded(child: content),
                  ],
                ),
      ),
    );
  }
}
