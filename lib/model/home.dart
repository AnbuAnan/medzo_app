import 'package:medzo/models/appointment_data.dart';

class Home {
  final List<AppointmentData> appointments;
  final DateTime today;
  final DateTime selectedDate;
  final List<AppointmentData> filteredAppointments;
  final List<AppointmentData> neededAppointments;
  final Map<String, String?> preCheckPrameters;
  final Map<String, dynamic> preCheckDetails;
  final bool isPrecheckFetching;
  final String? searchText;
  final bool isDataFetching;
  final bool newuser;
  final bool hasShownModal;
  final int newPatientCount;
  final int existPatientCount;
  final bool errorOccurs;
  final String errorText;
  final bool isDataFetched;

  Home({
    required this.appointments,
    required this.today,
    required this.selectedDate,
    required this.filteredAppointments,
    required this.neededAppointments,
    required this.preCheckDetails,
    required this.preCheckPrameters,
    required this.isPrecheckFetching,
    this.searchText,
    required this.isDataFetching,
    required this.newuser,
    required this.hasShownModal,
    required this.newPatientCount,
    required this.existPatientCount,
    required this.errorOccurs,
    required this.errorText,
    required this.isDataFetched,
  });

  Home copyWith({
    List<AppointmentData>? appointments,
    DateTime? today,
    DateTime? selectedDate,
    List<AppointmentData>? filteredAppointments,
    List<AppointmentData>? neededAppointments,
    Map<String, dynamic>? preCheckDetails,
    Map<String, String?>? preCheckPrameters,
    bool? isPrecheckFetching,
    String? searchText,
    bool? isDataFetching,
    bool? newUser,
    bool? hasShownModal,
    int? newPatientCount,
    int? existPatientCount,
    bool? errorOccurs,
    String? errorText,
    bool? isDataFetched,
  }) {
    return Home(
      appointments: appointments ?? this.appointments,
      today: today ?? this.today,
      selectedDate: selectedDate ?? this.selectedDate,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      neededAppointments: neededAppointments ?? this.neededAppointments,
      preCheckDetails: preCheckDetails ?? this.preCheckDetails,
      preCheckPrameters: preCheckPrameters ?? this.preCheckPrameters,
      isPrecheckFetching: isPrecheckFetching ?? this.isPrecheckFetching,
      searchText: searchText ?? this.searchText,
      isDataFetching: isDataFetching ?? this.isDataFetching,
      newuser: newUser ?? newuser,
      hasShownModal: hasShownModal ?? this.hasShownModal,
      newPatientCount: newPatientCount ?? this.newPatientCount,
      existPatientCount: existPatientCount ?? this.existPatientCount,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
      isDataFetched: isDataFetched ?? this.isDataFetched,
    );
  }
}
