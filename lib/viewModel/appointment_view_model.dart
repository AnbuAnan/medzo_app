import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/appointment.dart';
import 'package:medzo/util/strings.dart';

class AppointmentViewModel extends StateNotifier<Appointment> {
  AppointmentViewModel()
      : super(Appointment(
          formType: Strings.appointmentFormTypeNew,
          availTimeSlots: null,
          date: null,
          followupId: null,
          followupName: null,
          time: null,
        ));

  void updateFormType(String value) {
    state = state.copyWith(formType: value);
  }
}

final appointmentViewModelProvider =
    StateNotifierProvider<AppointmentViewModel, Appointment>((ref) {
  return AppointmentViewModel();
});
