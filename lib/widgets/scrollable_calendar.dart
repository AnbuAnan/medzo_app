// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class ScrollableCalendar extends StatefulWidget {
  const ScrollableCalendar({super.key, required this.onPassDate});

  final Function(BuildContext, DateTime) onPassDate;

  @override
  State<ScrollableCalendar> createState() => ScrollableCalendarState();
}

class ScrollableCalendarState extends State<ScrollableCalendar> {
  DateTime selectedDate = DateTime.now(); 
  int? selectedMonth;
  int? selectedYear;
  final ScrollController _scrollController = ScrollController();

  List<String> dayNames = Strings.weekshortNameList;
  List<String> months = Strings.monthFullNameList;

  @override
  void initState() {
    super.initState();
    _initDatesRow();
  }

  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

  void _initDatesRow() {
    
    DateTime now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    selectedMonth = now.month;
    selectedYear = now.year;

    int selectedIndex = now.day - 2; 
    double targetOffset =
        selectedIndex * 64.0; 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    _scrollToDate(now.day);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedMonth = picked.month;
        selectedYear = picked.year;
      });

      _scrollToDate(picked.day);
      widget.onPassDate(context, selectedDate);

      debugPrint('${selectedDate.day}-${selectedDate.month}-${selectedDate.year}');
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  List<int> _getDaysInMonth(int month, int year) {
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    return List<int>.generate(daysInMonth, (int index) => index + 1);
  }

  String _getDayOfWeek(int year, int month, int day) {
    final DateTime date = DateTime(year, month, day);
    final int weekDayIndex = date.weekday % 7; 
    return dayNames[weekDayIndex];
  }

  void _scrollToDate(int day) {
    int selectedIndex = day - 1;

    double targetOffset = selectedIndex * 55.0 +
        selectedIndex * 8 -
        63; 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleDateTap(int day) {
    setState(() {
      selectedDate = DateTime(selectedYear!, selectedMonth!, day);
    });
    widget.onPassDate(context, selectedDate);
    _scrollToDate(day);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${months[selectedDate.month - 1]} ${selectedDate.year}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _selectDate(context),
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
        if (selectedMonth != null && selectedYear != null)
          SizedBox(
            height: 80,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _getDaysInMonth(selectedMonth!, selectedYear!).length,
              itemBuilder: (BuildContext context, int index) {
                final int day =
                    _getDaysInMonth(selectedMonth!, selectedYear!)[index];
                final String dayOfWeek =
                    _getDayOfWeek(selectedYear!, selectedMonth!, day);
                final bool isSelected = selectedDate.day == day;

                return GestureDetector(
                  onTap: () => _handleDateTap(day),
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
