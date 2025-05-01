import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends ConsumerState<Calendar> {
  @override
  void initState() {
    var action = ref.read(scheduleListViewModelProvider.notifier);
    action.initDatesRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(scheduleListViewModelProvider);
    var authState = ref.watch(authProvider);
    var action = ref.read(scheduleListViewModelProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${action.months[state.selectedDate.month - 1]} ${state.selectedDate.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)),
            GestureDetector(
              onTap: () => action.selectDate(context,authState.userDetails![ApiKeyEnum.doctorId.key]),
              child: CircleAvatar(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
                radius: 20,
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            controller: state.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: action
                .getDaysInMonth(
                    state.selectedDate.month, state.selectedDate.year)
                .length,
            itemBuilder: (BuildContext context, int index) {
              final int day = action.getDaysInMonth(
                  state.selectedDate.month, state.selectedDate.year)[index];
              final String dayOfWeek = action.getDayOfWeek(
                  state.selectedDate.year, state.selectedDate.month, day);
              final bool isSelected = state.selectedDate.day == day;

              return GestureDetector(
                onTap: () => action.handleDateTap(context, day,authState.userDetails![ApiKeyEnum.doctorId.key].toString()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4), 
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: isSelected ? 0 : 1,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: isSelected
                                  ? [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                    ]
                                  : [Colors.white, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayOfWeek,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                            const SizedBox(
                                height:
                                    4), 
                            Text(
                              '$day',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
