// ignore_for_file: prefer_iterable_wheretype, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/existing_appointment.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

class ExistingAppointmentViewModel extends StateNotifier<ExistingAppointment> {
  ExistingAppointmentViewModel()
    : super(
        ExistingAppointment(
          searchFieldController: TextEditingController(),
          patientOrCaseIdOptions: [],
          displayedOptions: [],
          selectedPatientNameOrID: null,
          selectedPatientID: null,
          selectedPatientName: null,
          userInfo: null,
          dateController: TextEditingController(),
          selectedDate: null,
          cheifComplaintController: TextEditingController(),
          selectedAppointmentType: null,
          selectedReportFile: null,
          isItemSelected: false,
          followUpPatientId: TextEditingController(),
          reSchedulePatientId: TextEditingController(),
          isSelectedFollowupTimeSlot: null,
          isSuggestionSelected: false,
          availableSlots: [],
          isBooking: false,
          appointmentId: null,
          reportFileMax: false,
        ),
      );

  Timer? _debounce;

  void onSearchTextChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.contains(Strings.forwardSlashSymbol)) {
        updateDisplayedOptions([]);
        return;
      }

      onSearch(query, context);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void updateisItemSelected(bool value) {
    state = state.copyWith(isItemSelected: value);
  }

  void updatePatientOrCaseIdOptions(List<String> options) {
    state = state.copyWith(patientOrCaseIdOptions: options);
  }

  void updateSelectedPatientID(int? id) {
    state = state.copyWith(selectedPatientID: id);
  }

  void updateSelectedPatientName(String? name) {
    state = state.copyWith(selectedPatientName: name);
  }

  void updateselecteddate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateIsSelectedFollowUpTimeSlot(TimeSlot? slot) {
    state = state.copyWith(isSelectedFollowupTimeSlot: slot);
    debugPrint('${state.isSelectedFollowupTimeSlot!.startTime}');
  }

  void updateSelectedAppointmentType(String? type) {
    state = state.copyWith(selectedAppointmentType: type);
  }

  void updatereportFileMax(bool value) {
    state = state.copyWith(reportFileMax: value);
  }

  void updateSelectedReportFile(PlatformFile? file) {
    state = ExistingAppointment(
      selectedReportFile: file,
      searchFieldController: state.searchFieldController,
      dateController: state.dateController,
      cheifComplaintController: state.cheifComplaintController,
      followUpPatientId: state.followUpPatientId,
      reSchedulePatientId: state.reSchedulePatientId,
      isSuggestionSelected: state.isSuggestionSelected,
      availableSlots: state.availableSlots,
      displayedOptions: state.displayedOptions,
      isItemSelected: state.isItemSelected,
      isSelectedFollowupTimeSlot: state.isSelectedFollowupTimeSlot,
      patientOrCaseIdOptions: state.patientOrCaseIdOptions,
      selectedAppointmentType: state.selectedAppointmentType,
      selectedDate: state.selectedDate,
      selectedPatientID: state.selectedPatientID,
      selectedPatientName: state.selectedPatientName,
      selectedPatientNameOrID: state.selectedPatientNameOrID,
      userInfo: state.userInfo,
      reportFileMax: state.reportFileMax,
      isBooking: false,
    );
    if (file!.size > 2 * 1024 * 1024) {
      updatereportFileMax(true);
    } else {
      updatereportFileMax(false);
    }
  }

  void updateIsBooking(bool value) {
    state = state.copyWith(isBooking: value);
  }

  void updateAppointmentId(int? id) {
    state = state.copyWith(appointmentId: id);
  }

  void updateDobController() {
    state = state.copyWith(
      dateController: TextEditingController(
        text:
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      ),
    );
  }

  void updateAvailableSlots(List<TimeSlot> availableSlots) {
    state = state.copyWith(availableSlots: availableSlots);
  }

  // Function to launch a phone call
  Future<void> launchPhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: Strings.callScheme, path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Strings.subscribePopupMakeCallErrorText,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void getSelectedUserData(String? value) {
    List<String> splitter = value!.split(Strings.forwardSlashSymbol);
    String name = splitter[0];
    String idString = splitter[1];
    int id = int.parse(idString);

    updateSelectedPatientName(name);
    updateSelectedPatientID(id);

    return;
  }

  void updateDisplayedOptions(List<dynamic> options) {
    state = state.copyWith(displayedOptions: options);
  }

  Future<List<String>> fetchPatientNamesFromAPI(
    String query, {
    required BuildContext context,
  }) async {
    var response = await AppointmentService.checkPatientDetailswithQuery(
      context,
      mounted,
      query,
    );

    if (response is! List) {
      updateDisplayedOptions([]);
      return [];
    }

    List<String> formattedNames =
        response
            .where((patient) => patient is Map<String, dynamic>)
            .map<String>(
              (patient) =>
                  "${patient[ApiKeyEnum.patientName.key]}${Strings.forwardSlashSymbol}${patient[ApiKeyEnum.patientId.key]}",
            )
            .toList();

    updateDisplayedOptions(formattedNames);

    return formattedNames;
  }

  Future<void> selectDate(BuildContext context, String doctorId) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      updateselecteddate(date);
      getAvailableSlotsDetails(context, doctorId);
      String formattedDate = "${date.day}/${date.month}/${date.year}";
      state.dateController.text = formattedDate;
    }
  }

  String convertToDateTimeString(DateTime date, TimeOfDay time) {
    final combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return '${combinedDateTime.toIso8601String().split('T')[0]}T${combinedDateTime.toString().substring(11, 19)}';
  }

  Future<void> onSearch(String query, BuildContext context) async {
    if (query.isNotEmpty) {
      await fetchPatientNamesFromAPI(query, context: context);
    } else {
      state.displayedOptions.clear();
    }
  }

  void onSuggestionTap(String? suggestion) {
    state.searchFieldController.text = suggestion!;
    getSelectedUserData(suggestion);

    state.displayedOptions.clear();
  }

  void getRescheduleAptDetails(
    BuildContext context,
    int doctorId,
    int? appointmentId,
  ) async {
    var response = await AppointmentService.getDetailsforSelectedApt(
      context,
      mounted,
      appointmentId!,
    );

    state.cheifComplaintController.text =
        response[ApiKeyEnum.chiefComplaint.key];
    state.dateController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    updateSelectedAppointmentType(response[ApiKeyEnum.appointmentType.key]);
    fetchReport(context, doctorId, appointmentId);
  }

  Future<void> fetchReport(
    BuildContext context,
    int doctorId,
    int appointmentId,
  ) async {
    try {
      var reportPredefinedURL = await AuthenticationService.getPredefinedURL(
        context,
        mounted,
        '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.appointmentId.key}${Strings.hypenText}$appointmentId',
        false,
      );
      debugPrint("Report PredefinedURL : $reportPredefinedURL");

      final reportFileBytes = await apiService.getFileByURL(
        reportPredefinedURL,
      );

      if (reportFileBytes.statusCode == 200) {
        saveFileAsPlatformFile(
          reportFileBytes.bodyBytes,
          '${ApiKeyEnum.report.key}${Strings.hypenText}$appointmentId',
          ApiKeyEnum.report.key,
        );
      } else if (reportFileBytes.statusCode == 404) {
        updateSelectedReportFile(null);
      }
    } catch (error) {
      rethrow;
    }
  }

  String getFileExtensionFromMime(bytes) {
    String? mimeType = lookupMimeType(Strings.emptySpace, headerBytes: bytes);
    if (mimeType != null) {
      return mimeType
          .split(Strings.forwardSlashSymbol)
          .last; // Extracts 'pdf', 'jpg', etc.
    }
    return Strings.unknownTxt;
  }

  void saveFile(dynamic fileBytes, String fileName, String fileType) async {
    String fileExt = getFileExtensionFromMime(fileBytes);

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName.$fileExt'; // Use the file extension

    final file = File(filePath);
    await file.writeAsBytes(fileBytes);
  }

  Future<void> saveFileAsPlatformFile(
    dynamic fileBytes,
    String fileName,
    String fileType,
  ) async {
    String fileExt = getFileExtensionFromMime(fileBytes);

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName.$fileExt';

    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    var report = PlatformFile(
      name: "$fileName.$fileExt",
      path: filePath, // Set the file path
      bytes: fileBytes, // Set the file bytes
      size: fileBytes.length, // Set file size
    );
    updateSelectedReportFile(report);
  }

  void handleBookAppointment(
    BuildContext context,
    DateTime date,
    TimeSlot timeSlot,
    int? followupPatientId,
    int? followupAppointmentId,
    int? outdatedId,
    int? outdatedAppointmentId,
    int? reSchedulePatientId,
    int? reSchedulePatientAppointmentId,
    String doctorId,
    Function reloadHome,
    Function reloadMySchedule,
    Function reloadScheduleListSlots,
    Function reloadScheduleListFollowups,
    Function reloadScheduleListOutdated,
  ) async {
    updateIsBooking(true);
    Map<String, dynamic> payload = {
      ApiKeyEnum.slotId.key: timeSlot.slotId,
      ApiKeyEnum.patientId.key:
          followupPatientId ??
          outdatedId ??
          reSchedulePatientId ??
          state.selectedPatientID,
      ApiKeyEnum.startTime.key:
          followupPatientId != null
              ? convertToDateTimeString(date, timeSlot.startTime)
              : convertToDateTimeString(
                state.selectedDate!,
                timeSlot.startTime,
              ),
      ApiKeyEnum.endTime.key:
          followupPatientId != null
              ? convertToDateTimeString(date, timeSlot.endTime)
              : convertToDateTimeString(state.selectedDate!, timeSlot.endTime),
      ApiKeyEnum.chiefComplaint.key: state.cheifComplaintController.text,
      ApiKeyEnum.appointmentType.key: state.selectedAppointmentType,
      ApiKeyEnum.report.key: state.selectedReportFile?.path,
    };

    try {
      if (state.appointmentId == null) {
        var response = await AppointmentService.createAppointment(
          context,
          mounted,
          payload,
        );
        updateAppointmentId(response);
      }
      if (state.appointmentId != null) {
        if (state.selectedReportFile == null) {
          moveToNextPage(
            context,
            followupPatientId,
            reSchedulePatientId,
            outdatedId,
          );
          reloadRelatedPages(
            context,
            date,
            doctorId.toString(),
            reloadHome,
            reloadMySchedule,
            reloadScheduleListSlots,
          );
        }

        if (state.selectedReportFile != null) {
          int reportStatus = await uploadReport(
            context,
            doctorId,
            state.appointmentId!.toString(),
          );

          if (reportStatus == 200) {
            reloadRelatedPages(
              context,
              date,
              doctorId.toString(),
              reloadHome,
              reloadMySchedule,
              reloadScheduleListSlots,
            );
            moveToNextPage(
              context,
              followupPatientId,
              reSchedulePatientId,
              outdatedId,
            );
          }
        }

        //Delete the followup after the appointment booked
        if (followupPatientId != null) {
          await deleteFollowup(context, followupAppointmentId!);
          reloadRelatedPages(
            context,
            state.selectedDate!,
            doctorId.toString(),
            reloadHome,
            reloadMySchedule,
            reloadScheduleListFollowups,
          );
        }

        //Delete the Outdated after the appointment booked
        if (outdatedId != null) {
          await deleteAppointment(context, outdatedAppointmentId!);
          reloadRelatedPages(
            context,
            state.selectedDate!,
            doctorId.toString(),
            reloadHome,
            reloadMySchedule,
            reloadScheduleListOutdated,
          );
        }

        //Delete the orginal appointment
        if (reSchedulePatientId != null) {
          await deleteAppointment(context, reSchedulePatientAppointmentId!);
          reloadRelatedPages(
            context,
            state.selectedDate!,
            doctorId.toString(),
            reloadHome,
            reloadMySchedule,
            reloadScheduleListSlots,
          );
        }
      }
    } finally {
      updateIsBooking(false);
    }
  }

  Future<int> uploadReport(
    BuildContext context,
    String doctorId,
    String appointmentId,
  ) async {
    File reportFile = File(state.selectedReportFile!.path!);
    Uint8List reportFileBytes = await reportFile.readAsBytes();
    var reportPredefinedURL = await AuthenticationService.getPredefinedURL(
      context,
      mounted,
      '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.appointmentId.key}${Strings.hypenText}${state.appointmentId}',
      true,
    );

    int reportResponse = await AuthenticationService.uploadFile(
      context,
      mounted,
      reportPredefinedURL,
      reportFileBytes,
    );
    updatereportFileMax(false);
    return reportResponse;
  }

  void reloadRelatedPages(
    BuildContext context,
    DateTime date,
    String? doctorId,
    Function reloadHome,
    Function reloadMySchedule,
    Function reloadScheduleList,
  ) {
    reloadHome(context);

    if (doctorId != null &&
        reloadMySchedule is Function(BuildContext, bool, String)) {
      reloadMySchedule(context, false, doctorId);
    } else if (reloadMySchedule is Function(BuildContext, bool)) {
      reloadMySchedule(context, false);
    } else {
      reloadMySchedule(context);
    }

    if (doctorId != null &&
        reloadScheduleList is Function(BuildContext, bool, String)) {
      reloadScheduleList(context, false, doctorId);
    } else if (reloadScheduleList is Function(BuildContext, bool)) {
      reloadScheduleList(context, false);
    } else {
      reloadScheduleList(context);
    }
  }

  void moveToNextPage(
    BuildContext context,
    int? followupPatientId,
    int? reSchedulePatientId,
    int? outdatedId,
  ) {
    Future.delayed(const Duration(seconds: 1), () {
      clearFields();
    });

    if (followupPatientId == null &&
        reSchedulePatientId == null &&
        outdatedId == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DefaultTabView(pageIndex: 0),
        ),
      );
    } else {
      Navigator.of(context).maybePop().then((_) {});
    }
  }

  Future<void> deleteFollowup(BuildContext context, int followupId) async {
    await AppointmentService.deleteFollowup(context, mounted, followupId);
  }

  Future<void> deleteAppointment(
    BuildContext context,
    int appointmentId,
  ) async {
    await AppointmentService.deleteAppointment(context, mounted, appointmentId);
  }

  void getAvailableSlotsDetails(BuildContext context, String doctorId) async {
    updateAvailableSlots([]);
    var slotResponse = await AppointmentService.getSlotsForSelectedDay(
      context,
      mounted,
      state.selectedDate!,
      doctorId,
    );

    if (slotResponse is List) {
      List<TimeSlot> newSlots = convertToTimeSlots(slotResponse);
      updateAvailableSlots(newSlots);
    }
  }

  List<TimeSlot> convertToTimeSlots(dynamic overallSlots) {
    List<TimeSlot> timeSlots = [];

    for (var slot in overallSlots) {
      DateTime startDateTime = DateTime.parse(slot[ApiKeyEnum.startTime.key]);
      DateTime endDateTime = DateTime.parse(slot[ApiKeyEnum.endTime.key]);
      bool isBooked = slot[ApiKeyEnum.isBooked.key] ?? false;
      int? patientId = slot[ApiKeyEnum.patientId.key];
      String? patientName = slot[ApiKeyEnum.patientName.key];

      TimeSlot timeSlot = TimeSlot(
        slotId: slot[ApiKeyEnum.slotId.key], // Add slotId
        doctorId: slot[ApiKeyEnum.doctorId.key].toString(), // Add doctorId
        startTime: TimeOfDay.fromDateTime(startDateTime),
        endTime: TimeOfDay.fromDateTime(endDateTime),
        isBooked: isBooked,
        patientId: patientId,
        patientName: patientName,
      );

      if (!timeSlot.isBooked &&
          !isPastTime(TimeOfDay.fromDateTime(startDateTime))) {
        timeSlots.add(timeSlot);
      }
    }

    return timeSlots;
  }

  bool isPastDay(DateTime date) {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(date.year, date.month, date.day);

    return targetDate.isBefore(today);
  }

  bool isPastTime(TimeOfDay time) {
    DateTime targetDateTime = DateTime(
      state.selectedDate!.year,
      state.selectedDate!.month,
      state.selectedDate!.day,
      time.hour,
      time.minute,
    );

    return targetDateTime.isBefore(DateTime.now());
  }

  void clearFields() {
    Future.delayed(const Duration(milliseconds: 1), () {
      state.searchFieldController.clear();
      state.cheifComplaintController.clear();
      updateAppointmentId(null);

      state = ExistingAppointment(
        selectedAppointmentType: null,
        selectedReportFile: null,
        searchFieldController: state.searchFieldController,
        dateController: state.dateController,
        cheifComplaintController: state.cheifComplaintController,
        followUpPatientId: state.followUpPatientId,
        reSchedulePatientId: state.reSchedulePatientId,
        isSuggestionSelected: state.isSuggestionSelected,
        isBooking: state.isBooking,
        reportFileMax: state.reportFileMax,
      );
    });
  }
}

final existingAppointmentViewModelProvider =
    StateNotifierProvider<ExistingAppointmentViewModel, ExistingAppointment>((
      ref,
    ) {
      return ExistingAppointmentViewModel();
    });
