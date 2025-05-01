import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/add_followup_view_model.dart';
import 'package:medzo/viewModel/followup_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

class AddFollowupView extends ConsumerStatefulWidget {
  const AddFollowupView(
      {super.key,
      required this.patientName,
      required this.patientId,
      required this.parentContext});

  final String patientName;
  final int patientId;
  final BuildContext parentContext;
  @override
  AddFollowupViewState createState() => AddFollowupViewState();
}

class AddFollowupViewState extends ConsumerState<AddFollowupView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(addFollowupViewModelProvider.notifier);
      action.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(addFollowupViewModelProvider);
    var action = ref.read(addFollowupViewModelProvider.notifier);
    var scheduleListAction = ref.read(scheduleListViewModelProvider.notifier);
    var followupAction = ref.read(followupViewModelProvider.notifier);

    Widget content = Center(
      child: Text(Strings.noFollowUpsMsg,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white)),
    );

    if (state.followupList.isNotEmpty) {
      content = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: state.followupList.map((followupDate) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${followupDate.date.day} ${action.months[followupDate.date.month - 1].substring(0, 3)}, ${followupDate.date.year}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        '${followupDate.followUpDatas.length} ${Strings.followUpText}${followupDate.followUpDatas.length != 1 ? Strings.sText : Strings.emptySpace}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: followupDate.followUpDatas
                        .map(
                          (data) => Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(242, 242, 245, 255),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      AssetImage(Images.patientProfile),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.patientName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text('${Strings.caseIDLabelText}${data.patientId}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12)
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.2,
      maxChildSize: 1.0,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              margin: const EdgeInsets.only(top: 18),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.2),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryFixed,
                  borderRadius: BorderRadius.circular(20)),
            ),
            TableCalendar(
              firstDay: state.today,
              lastDay: state.today.add(const Duration(days: 120)),
              focusedDay: state.focusedDay!,
              selectedDayPredicate: (day) {
                return isSameDay(state.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                action.onDaySelected(widget.parentContext, context, selectedDay,
                    focusedDay, widget.patientName, widget.patientId,followupAction.getFollowups,scheduleListAction.fetchFollowups);
              },
              onPageChanged: (focusedDay) {
                action.updateFocusedDay(focusedDay);
                action.getFollowups(context);
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
                    color: Theme.of(context).colorScheme.primaryFixed,
                  ),
                  color: Colors.white,
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
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
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
              rowHeight: 48,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  bool hasTimeSlots = state.followupList
                      .any((slot) => isSameDay(slot.date, day));
                  if (hasTimeSlots) {
                    return Positioned(
                      bottom: 6,
                      child: Container(
                        width: 5.0,
                        height: 5.0,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255,
                              255), // Customize the color of the dot
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 0.8,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: content,
            )
          ],
        ),
      ),
    );
  }
}
