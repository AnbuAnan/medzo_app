class AppointmentDetails {
  final int appointmentId;
  final int slotId;

  final int patientId;
  final String startTime;
  final String endTime;
  final String chiefComplaint;
  final String appointmentType;
  final String appointmentStatus;

  AppointmentDetails({
    required this.appointmentId,
    required this.slotId,
    required this.patientId,
    required this.startTime,
    required this.endTime,
    required this.chiefComplaint,
    required this.appointmentType,
    required this.appointmentStatus,
  });
}

class PatientProfile {
  final String patientName;
  final String? gender;
  final String? phoneNumber;
  final String? pastHistory;
  final String? personalHistory;
  final String? cheifComplaint;
  final bool isFetchingPersonalInfo;
  final bool isFetchingNewAptInfo;
  final bool isFetchingAptList;
  final bool errorOccurs;
  final String errorText;

  final List<dynamic> appointments;
  final Map<String, dynamic> personalData;
  final Map<String, dynamic> pastHistoryData;

  PatientProfile({
    required this.patientName,
    this.cheifComplaint,
    this.gender,
    this.phoneNumber,
    this.pastHistory,
    this.personalHistory,
    required this.appointments,
    required this.isFetchingPersonalInfo,
    required this.isFetchingNewAptInfo,
    required this.isFetchingAptList,
    required this.personalData,
    required this.pastHistoryData,
    required this.errorOccurs,
    required this.errorText,
  });

  PatientProfile copyWith({
    String? patientName,
    List<dynamic>? appointments,
    String? cheifComplaint,
    String? gender,
    String? phoneNumber,
    String? pastHistory,
    String? personalHistory,
    bool? isFetchingPersonalInfo,
    bool? isFetchingNewAptInfo,
    bool? isFetchingAptList,
    Map<String, dynamic>? personalData,
    Map<String, dynamic>? pastHistoryData,
    bool? errorOccurs,
    String? errorText,
  }) {
    return PatientProfile(
        patientName: patientName ?? this.patientName,
        cheifComplaint: cheifComplaint ?? this.cheifComplaint,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        pastHistory: pastHistory ?? this.pastHistory,
        personalHistory: personalHistory ?? this.personalHistory,
        appointments: appointments ?? this.appointments,
        isFetchingPersonalInfo:
            isFetchingPersonalInfo ?? this.isFetchingPersonalInfo,
        isFetchingNewAptInfo: isFetchingNewAptInfo ?? this.isFetchingNewAptInfo,
        isFetchingAptList: isFetchingAptList ?? this.isFetchingAptList,
        personalData: personalData ?? this.personalData,
        pastHistoryData: pastHistoryData ?? this.pastHistoryData,
        errorOccurs: errorOccurs ?? this.errorOccurs,
        errorText: errorText ?? this.errorText,
        );
  }
}
