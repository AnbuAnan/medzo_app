import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';

class SlotbookingBottomsheet extends ConsumerStatefulWidget {
  const SlotbookingBottomsheet(
      {super.key, required this.parentCntxt, required this.selectedDate});

  final BuildContext parentCntxt;
  final DateTime selectedDate;

  @override
  SlotbookingBottomsheetState createState() => SlotbookingBottomsheetState();
}

class SlotbookingBottomsheetState
    extends ConsumerState<SlotbookingBottomsheet> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(myScheduleViewModelProvider);
    var authState = ref.watch(authProvider);
    var action = ref.read(myScheduleViewModelProvider.notifier);
    DateTime selectedDate = widget.selectedDate;
    String date =
        "${selectedDate.day < 10 ? '${Strings.singleZeroLabel}${selectedDate.day}' : selectedDate.day} ${action.months[selectedDate.month - 1].substring(0, 3)}, ${selectedDate.year}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${Strings.addTimeSlotTitle} $date',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  action.pickStartTime(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        state.startTime != null
                            ? state.startTime!.format(context)
                            : Strings.addTimeSlotStartTime,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  action.pickEndTime(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        state.endTime != null
                            ? state.endTime!.format(context)
                            : Strings.addTimeSlotEndTime,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (state.createSlotError != null) ...[
            const SizedBox(height: 12),
            Text(
              state.createSlotError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  action.updateUi(); 
                },
                child: Text(
                  Strings.addTimeSlotCancelBtn,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
                onPressed: () {
                  action.updateLastSelectedDay(widget.selectedDate);
                  action.submitSlot(context, widget.parentCntxt,
                      selectedDate,authState.userDetails![ApiKeyEnum.doctorId.key].toString()); 
                },
                child: Text(
                  Strings.addTimeSlotSubmitBtn,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}