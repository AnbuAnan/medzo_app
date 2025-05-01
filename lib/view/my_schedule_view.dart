import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/skeleton/my_schedule_skeleton.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';
import 'package:medzo/widgets/paste_snackbar.dart';
import 'package:table_calendar/table_calendar.dart';

class MyScheduleView extends ConsumerStatefulWidget {
  const MyScheduleView({super.key});

  @override
  MyScheduleViewState createState() => MyScheduleViewState();
}

class MyScheduleViewState extends ConsumerState<MyScheduleView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(myScheduleViewModelProvider.notifier);
      var authState = ref.watch(authProvider);
  action.initialize(
        context,
        authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(myScheduleViewModelProvider);
    var authState = ref.watch(authProvider);
    var action = ref.read(myScheduleViewModelProvider.notifier);

    Widget buildTimeSlotsList(DateSlots dateSlot) {
      int buttonIndex = -1;
      final List<dynamic> items = List.from(dateSlot.timeSlots)
        ..add(buttonIndex);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: action.crossAxisCount,
          crossAxisSpacing: 6,
          mainAxisSpacing: 8,
          childAspectRatio: action.aspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (items[index] == buttonIndex) {
            if (!action.isPastDate(dateSlot)) {
              return GestureDetector(
                onTap: () {
                  action.showDateBottomSheet(context, dateSlot.date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.addTimeSlotText,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 6),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            final timeSlot = items[index] as TimeSlot;
            return GestureDetector(
              onTap:
                  state.isSelecting && dateSlot == state.selectedDateSlot
                      ? () {
                        final newSelectedSlots = List<TimeSlot>.from(
                          state.selectedSlots,
                        );
                        if (state.selectedSlots.contains(timeSlot)) {
                          if (state.selectedSlots.length == 1 &&
                              state.selectedSlots[0].slotId ==
                                  timeSlot.slotId) {
                            action.updateIsSelecting(false);
                            action.updateSelectedDay(null);

                            action.updateSelectedSlots([]);
                            action.updateSelectedDates([]);

                            action.updateIsMultiSelectEnabled(false);
                            action.updateIsAllCopied(false);
                          }
                          newSelectedSlots.remove(timeSlot);
                        } else {
                          newSelectedSlots.add(timeSlot);
                        }
                        action.updateSelectedSlots(newSelectedSlots);

                        if (state.selectedSlots.isEmpty) {
                          action.updateIsSelecting(false);
                          action.updateSelectedDay(null);

                          action.updateSelectedSlots([]);
                          action.updateSelectedDates([]);

                          action.updateIsMultiSelectEnabled(false);
                          action.updateIsAllCopied(false);
                          return;
                        }
                      }
                      : state.isDeleting &&
                          dateSlot == state.selectedDateSlot &&
                          !timeSlot.isBooked
                      ? () {
                        setState(() {
                          dateSlot.timeSlots.remove(timeSlot);
                          if (dateSlot.timeSlots.isEmpty) {
                            action.changeAllSlots(dateSlot, Strings.removeText);
                          }
                        });
                        action.deleteSlots(
                          context,
                          [timeSlot.slotId],
                          dateSlot.timeSlots.length,
                          dateSlot.date,
                          authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                        );
                      }
                      : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                decoration: BoxDecoration(
                  border:
                      (state.selectedSlots.contains(timeSlot) &&
                              dateSlot == state.selectedDateSlot &&
                              !state.isDeleting)
                          ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          )
                          : (state.isDeleting &&
                              dateSlot == state.selectedDateSlot &&
                              !timeSlot.isBooked)
                          ? Border.all(
                            color: Theme.of(context).colorScheme.error,
                          )
                          : null,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color:
                      (state.selectedSlots.contains(timeSlot) &&
                              dateSlot == state.selectedDateSlot &&
                              !state.isDeleting)
                          ? Theme.of(context).colorScheme.primaryContainer
                          : (state.isDeleting &&
                              dateSlot == state.selectedDateSlot &&
                              !timeSlot.isBooked)
                          ? Theme.of(context).colorScheme.onError
                          : timeSlot.isBooked
                          ? Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer.withOpacity(0.5)
                          : Theme.of(context).colorScheme.primaryFixedDim,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${timeSlot.startTime.format(context)} - ${timeSlot.endTime.format(context)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if ((state.isSelecting &&
                        state.selectedSlots.contains(timeSlot) &&
                        dateSlot == state.selectedDateSlot))
                      Icon(
                        Icons.do_not_disturb_on_rounded,
                        size: 22,
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withOpacity(0.8),
                      ),
                    if (state.isDeleting &&
                        dateSlot == state.selectedDateSlot &&
                        !timeSlot.isBooked)
                      Icon(
                        Icons.clear,
                        size: 22,
                        color: Theme.of(context).colorScheme.error,
                      ),
                  ],
                ),
              ),
            );
          }
          return null;
        },
      );
    }

    Widget content = Expanded(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white,
          ),
          child:
              state.isFetching
                  ? const MyScheduleSkeleton()
                  : state.allSlots.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (action.checkMonth(state.focusedDay!) != -1)
                          Text(
                            action.checkMonth(state.focusedDay!) == 0
                                ? '${state.today.day} ${action.months[state.today.month - 1]}, ${state.today.year}'
                                : '${state.focusedDay!.day} ${action.months[state.focusedDay!.month - 1]}, ${state.focusedDay!.year}',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        const SizedBox(height: 12),
                        action.checkMonth(state.focusedDay!) == -1
                            ? Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      Images.noSlotsImg,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      Strings.noDataText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(Strings.noScheduleMsg),
                                  ],
                                ),
                              ),
                            )
                            : GestureDetector(
                              onTap: () {
                                action.showDateBottomSheet(
                                  context,
                                  state.focusedDay!,
                                );
                              },
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Strings.addTimeSlotText,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 10,
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    controller: state.scrollDate,
                    itemCount: state.allSlots.length,
                    itemBuilder: (context, index) {
                      DateSlots dateSlot = state.allSlots[index];
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: (index == state.blinkingIndex) ? 0.3 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${dateSlot.date.day} ${action.months[dateSlot.date.month - 1]}, ${dateSlot.date.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  if (state.selectedSlots.isNotEmpty &&
                                      state.isDeleting == false &&
                                      state.selectedDateSlot == dateSlot)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            action.updateIsSelecting(false);
                                            action.updateSelectedDay(null);
                                            state.selectedSlots.clear();
                                            action.updateIsMultiSelectEnabled(
                                              false,
                                            );
                                            state.selectedSlots.clear();
                                            action.updateIsAllCopied(false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.clear_rounded,
                                                  size: 20,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  Strings.cancelBtnText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).colorScheme.error,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            action.updateIsAllCopied(true);
                                            action.updateSelectedSlots(
                                              List.from(dateSlot.timeSlots),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  state.isAllCopied
                                                      ? Icons.library_add_check
                                                      : Icons.copy_outlined,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  state.isAllCopied
                                                      ? Strings.copyiedText
                                                      : Strings.copyAllText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (state.isDeleting &&
                                      state.isSelecting == false &&
                                      state.selectedDateSlot == dateSlot)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            action.updateIsDeleting(false);

                                            action.updateIsSelecting(false);
                                            action.updateSelectedDay(null);
                                            action.updateIsMultiSelectEnabled(
                                              false,
                                            );
                                            state.selectedSlots.clear();
                                            action.updateIsAllCopied(false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.clear_rounded,
                                                  size: 20,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  Strings.cancelBtnText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).colorScheme.error,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            List<int> slotIds = action
                                                .getSlotIds(dateSlot.timeSlots);
                                            action.deleteSlots(
                                              context,
                                              slotIds,
                                              null,
                                              dateSlot.date,
                                              authState.userDetails![ApiKeyEnum
                                                  .doctorId
                                                  .key].toString(),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  Strings.deleteAllText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      action.onMenuOptionSelected(
                                        value,
                                        dateSlot,
                                      );
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem<String>(
                                          value: Strings.copyText,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.copy, size: 18),
                                              const SizedBox(width: 8),
                                              Text(
                                                Strings.copyText,
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!action.isPastDate(dateSlot))
                                          PopupMenuItem<String>(
                                            value: Strings.deleteItemText,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.delete_outline_outlined,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  Strings.deleteItemText,
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ];
                                    },
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      size: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              buildTimeSlotsList(dateSlot),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            action.updateSelectedDay(null);
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          Strings.myScheduleAppBarTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              action.setNow(context);
            },
            icon: Icon(
              Icons.check_circle_outline_rounded,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body:
          (!state.isFetching && state.errorOccurs)
              ? ExceptionHandlingView(
                errorText: state.errorText,
                retryFunc: () {
                  action.getSlotDetails(
                    context,
                    true,
                    authState.userDetails![ApiKeyEnum.doctorId.key],
                  );
                },
              )
              : Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8,
                          top: 8,
                        ),
                        child: Text(
                          Strings.myScheduleDescription,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TableCalendar(
                                firstDay: DateTime(2024, 10, 1),
                                lastDay: state.endDate,
                                focusedDay: state.focusedDay!,
                                selectedDayPredicate: (day) {
                                  if (state.isMultiSelectEnabled) {
                                    return state.selectedDates.contains(day);
                                  }
                                  return state.selectedDay != null
                                      ? isSameDay(state.selectedDay, day)
                                      : false;
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  if (state.isMultiSelectEnabled) {
                                    if (action.isFutureDate(selectedDay)) {
                                      action.onDaySelected(
                                        context,
                                        selectedDay,
                                        focusedDay,
                                      );
                                    } else {
                                      return;
                                    }
                                  } else {
                                    action.onDaySelected(
                                      context,
                                      selectedDay,
                                      focusedDay,
                                    );
                                  }
                                },
                                onPageChanged: (focusedDay) {
                                  action.updateLastSelectedDay(state.today);
                                  action.updateFocusedDay(focusedDay);
                                  action.getSlotDetails(
                                    context,
                                    true,
                                    authState.userDetails![ApiKeyEnum
                                        .doctorId
                                        .key].toString(),
                                  );
                                },
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color:
                                          state.isSelecting &&
                                                  state
                                                      .selectedDates
                                                      .isNotEmpty &&
                                                  state.selectedDay ==
                                                      state.focusedDay
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.primaryFixed
                                              : Theme.of(
                                                context,
                                              ).colorScheme.primaryFixed,
                                    ),
                                    color:
                                        state.isSelecting &&
                                                state.selectedDay ==
                                                    state.focusedDay
                                            ? Colors.white
                                            : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  todayTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  outsideDaysVisible: false,
                                  weekendTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  defaultTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                headerStyle: HeaderStyle(
                                  headerPadding: const EdgeInsets.only(
                                    bottom: 4,
                                  ),
                                  titleTextStyle: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  leftChevronIcon: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  rightChevronIcon: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                daysOfWeekStyle: const DaysOfWeekStyle(
                                  weekdayStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  weekendStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                daysOfWeekHeight: 20,
                                rowHeight: 48,
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, day, events) {
                                    bool hasTimeSlots = state.allSlots.any(
                                      (slot) => isSameDay(slot.date, day),
                                    );
                                    if (hasTimeSlots) {
                                      return Positioned(
                                        bottom: 6,
                                        child: Container(
                                          width: 5.0,
                                          height: 5.0,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  content,
                  if (state.isSelecting &&
                      state.isMultiSelectEnabled &&
                      state.selectedDates.isNotEmpty &&
                      state.selectedSlots.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryFixedDim,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondaryFixed,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: PasteSnackbar(parentCntxt: context),
                      ),
                    ),
                ],
              ),
    );
  }
}
