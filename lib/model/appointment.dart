import 'package:medzo/models/slots.dart';

class Appointment {
  final DateTime? date;
  final TimeSlot? time;
  final List<TimeSlot>? availTimeSlots;
  final String? followupName;
  final int? followupId;
  final String formType;

  Appointment(
      {this.date,
      this.time,
      this.availTimeSlots,
      this.followupName,
      this.followupId,
      required this.formType});

  Appointment copyWith({
    DateTime? date,
    TimeSlot? time,
    List<TimeSlot>? availTimeSlots,
    String? followupName,
    int? followupId,
    String? formType,
  }) {
    return Appointment(
      date: date ?? this.date,
      time: time ?? this.time,
      availTimeSlots: availTimeSlots ?? this.availTimeSlots,
      followupName: followupName ?? this.followupName,
      followupId: followupId ?? this.followupId,
      formType: formType ?? this.formType,
    );
  }
}
