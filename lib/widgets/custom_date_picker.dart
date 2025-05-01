import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key, required this.selectedDates});

  final void Function(DateTime start, DateTime end) selectedDates;
  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  final DateRangePickerController _controller = DateRangePickerController();
  DateTime _currentDate = DateTime.now();
  final DateTime _startDate = DateTime(2002, 1, 1); 
  final DateTime _endDate = DateTime.now() ; 
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      setState(() {
        _selectedStartDate = args.value.startDate;
        _selectedEndDate = args.value.endDate;
      });
    } else if (args.value is DateTime) {
      setState(() {
       
        _selectedStartDate = args.value;
        _selectedEndDate = null; 
      });
    }
  }

  
  void _updateCalendar(DateTime newDate) {
    setState(() {
      if (newDate.isBefore(_startDate)) {
        newDate = _startDate;
      } else if (newDate.isAfter(_endDate)) {
        newDate = _endDate;
      }
      _controller.displayDate = newDate;
      _currentDate = newDate;
    });
  }

  
  String _formatDate(DateTime? date) {
    if (date == null) return Strings.customDpStartNotSelectedText;

   
    String day = date.day.toString().padLeft(2, Strings.singleZeroLabel);
    String month = date.month.toString().padLeft(2, Strings.singleZeroLabel);
    String year = date.year.toString();

    return '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left_rounded,
                    size: 30,
                    color: Color.fromARGB(158, 0, 0, 0),
                  ),
                  onPressed: () {
                    _updateCalendar(
                        DateTime(_currentDate.year - 1, _currentDate.month));
                  },
                ),

                Text(
                  " ${_currentDate.year}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(181, 0, 0, 0)),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    size: 30,
                    color: Color.fromARGB(158, 0, 0, 0),
                  ),
                  onPressed: () {
                    _updateCalendar(
                        DateTime(_currentDate.year + 1, _currentDate.month));
                  },
                ),
              ],
            ),
          ),
          SfDateRangePicker(
            allowViewNavigation: false,
            backgroundColor: Colors.white,
            showNavigationArrow: false,
            headerStyle: const DateRangePickerHeaderStyle(
              backgroundColor: Colors.transparent,
              textAlign: TextAlign.center,
            ),
            controller: _controller,
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: _onSelectionChanged,
            minDate: _startDate,
            maxDate: _endDate,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(34, 47, 38, 226),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    _selectedStartDate == null
                        ? Strings.customDpStartDateText
                        : _formatDate(_selectedStartDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                 Text(Strings.customDpHypenText),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(34, 47, 38, 226),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _selectedEndDate == null
                        ? Strings.customDpEndDateText
                        : _formatDate(_selectedEndDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      Strings.cancelBtnText,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blue),
                    )),
                const SizedBox(width: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    widget.selectedDates(
                        _selectedStartDate!, _selectedEndDate!);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(225, 39, 31, 224),
                            Color.fromARGB(221, 140, 135, 255),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        )),
                    child: Text(Strings.customDpApplyText,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getMonthName(int month) {
    List<String> months = Strings.monthFullNameList;
    return months[month - 1];
  }
}
