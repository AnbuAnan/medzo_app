import 'package:file_picker/file_picker.dart';

class NewUserAppointment {
  String patientId;
  String complaint;
  List<String> pastHistory;
  String? pastHistoryNotes;
  String hasPersonalHistory;
  List<String> personalHistory;
  String? personalHistoryNotes;
  String appointmentType;
  PlatformFile? report;

  NewUserAppointment({
    required this.patientId,
    required this.complaint,
    required this.pastHistory,
    this.pastHistoryNotes,
    required this.hasPersonalHistory,
    this.personalHistory = const [],
    this.personalHistoryNotes,
    required this.appointmentType,
    this.report,
  });
}

List<NewUserAppointment> newUserAppointments = [];
