import 'package:flutter/material.dart';


class TimeSlot {
  int slotId;
  String doctorId;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isBooked;
  int? patientId;
  String? patientName;
  int? appointmentId;

  TimeSlot({
    required this.slotId,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    this.patientId,
    this.patientName,
    this.appointmentId,
  });
}

class DateSlots {
  DateTime date;
  List<TimeSlot> timeSlots;

  DateSlots({
    required this.date,
    required this.timeSlots,
  });
}
