import 'package:file_picker/file_picker.dart';
import 'package:medzo/models/slots.dart';

class AddUserAppointment {
  String patientId;
  String patientName;
  DateTime selectedDate;
  TimeSlot time;
  PlatformFile? report;

  AddUserAppointment({
    required this.patientId,
    required this.patientName,
    required this.selectedDate,
    required this.time,
    this.report,
  });
}

List<AddUserAppointment> addUserAppointments = [
  // AddUserAppointment(
  //   patientId: "#2EGV23",
  //   patientName: "Yasvanth",
  //   selectedDate: DateTime.now(),
  //   time: TimeSlot(
  //     isBooked: true,
  //       startTime: TimeOfDay.now(),
  //       endTime: TimeOfDay.now(),
  //       slotId: 12,
  //       doctorId: "123"),
  //   complaint: "complaint",
  //   appointmentType: "appointmentType",
  // )
];
