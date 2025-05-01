import 'package:flutter/material.dart';

class AppointmentData {
  String? profilePicUrl;
  String patientName;
  int caseId;
  DateTime date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int doctorId;
  int? sitting;
  DateTime? followupdate;
  int? appointmentId;
  String? consultationStatus;
  String? patientStatus;
  String? cheifComplaint;
  String? lifeCycleStatus;

  AppointmentData({
    this.profilePicUrl,
    required this.patientName,
    required this.caseId,
    required this.date,
    this.startTime,
    this.endTime,
    required this.doctorId,
    this.sitting,
    this.followupdate,
    this.appointmentId,
    this.consultationStatus,
    this.patientStatus,
    this.cheifComplaint,
    this.lifeCycleStatus,
  });
}
