import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/followups_data.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/followup_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBottomSheet extends ConsumerStatefulWidget {
  const CalendarBottomSheet({
    super.key,
    required this.followup,
    required this.date,
  });

  final FollowUpData followup;
  final DateTime date;

  @override
  CalendarBottomSheetState createState() => CalendarBottomSheetState();
}

class CalendarBottomSheetState extends ConsumerState<CalendarBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(followupViewModelProvider);
    var action = ref.read(followupViewModelProvider.notifier);
    var scheduleListAction = ref.read(scheduleListViewModelProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                selectedDayPredicate:
                    (day) => isSameDay(day, state.rescheduleDate),
                onDaySelected: (selectedDay, focusedDay) {
                  action.updateRescheduleDate(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Theme.of(context).colorScheme.primaryFixed,
                    ),
                    color: const Color.fromARGB(225, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  todayTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  outsideDaysVisible: false,
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  headerPadding: const EdgeInsets.only(bottom: 4),
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
                  weekdayStyle: TextStyle(color: Colors.white, fontSize: 14),
                  weekendStyle: TextStyle(color: Colors.white, fontSize: 14),
                ),
                daysOfWeekHeight: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  action.updateRescheduleDate(DateTime.now());
                  Navigator.pop(context);
                },
                child: Text(
                  Strings.cancelBtnText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  // scheduleListAction.fetchFollowups(context, false);
                  action.updateFollowup(context, widget.followup,scheduleListAction.fetchFollowups);
                  action.updateRescheduleDate(DateTime.now());

                  Navigator.pop(context);
                },
                child: Text(
                  Strings.okayBtnText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
