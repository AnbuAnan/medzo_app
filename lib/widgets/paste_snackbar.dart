// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';

class PasteSnackbar extends ConsumerStatefulWidget {
  const PasteSnackbar({super.key, required this.parentCntxt});

  final BuildContext parentCntxt;

  @override
  PasteSnackbarState createState() => PasteSnackbarState();
}

class PasteSnackbarState extends ConsumerState<PasteSnackbar> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(myScheduleViewModelProvider);
    var authState = ref.watch(authProvider);
    var action = ref.read(myScheduleViewModelProvider.notifier);
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.file_copy_rounded, size: 20),
            Text(
              '${state.selectedSlots.length} Of ${state.selectedDateSlot!.timeSlots.length}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                state.selectedSlots.clear();
                action.updateSelectedDay(null);
                action.updateIsMultiSelectEnabled(false);
                state.selectedDates.clear();
                action.updateIsAllCopied(false);
                action.updateIsSelecting(false);
                action.selectedDayForCopy = null;
              },
              child: Text(
                Strings.cancelBtnText,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async {
                List<Map<String, dynamic>> data = action
                    .convertToSlotMapForPaste(
                      state.selectedDates,
                      state.selectedSlots,
                      authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                    );

                var response = await AppointmentService.createTimeSlot(
                  context,
                  mounted,
                  data,
                );

                if (response is List) {
                  
                  action.sortDateSlots();

                  // Clear the copied and selected slots and stop selecting
                  state.copiedSlots.clear();
                  state.selectedSlots.clear();
                  action.updateIsSelecting(false);
                  action.updateIsAllCopied(false);
                  action.updateLastSelectedDay(state.selectedDay!);
                  action.updateSelectedDay(null);
                  action.selectedDayForCopy = null;
                  action.updateIsMultiSelectEnabled(false);
                  state.selectedDates.clear();
                  action.getSlotDetails(
                    widget.parentCntxt,
                    true,
                    authState.userDetails![ApiKeyEnum.doctorId.key].toString(),
                  );
                }

                // _onDaySelected(selectedDay, selectedDay);
              },
              child: Text(
                Strings.pasteBtnText,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
