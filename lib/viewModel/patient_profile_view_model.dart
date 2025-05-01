// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/patient_profile.dart';
import 'package:medzo/network/patient_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/edit_patient_details_view.dart';

class PatientProfileViewModel extends StateNotifier<PatientProfile> {
  PatientProfileViewModel()
    : super(
        PatientProfile(
          patientName: Strings.undefiendText,
          gender: null,
          phoneNumber: null,
          cheifComplaint: null,
          pastHistory: null,
          personalHistory: null,
          appointments: [],
          isFetchingPersonalInfo: false,
          isFetchingNewAptInfo: false,
          isFetchingAptList: false,
          personalData: {},
          pastHistoryData: {},
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
        ),
      );

  void initialize(BuildContext context, int patientId, String patientName) {
    updatePatientName(patientName);
    fetchPastHistoryInfo(context, patientId);
    fetchAppointmentList(context, patientId);
    fetchPersonalInfo(context, patientId);
  }

  void updatePatientName(String name) {
    state = state.copyWith(patientName: name);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value);
  }

  void updatepersonalData(Map<String, dynamic> value) {
    state = state.copyWith(personalData: value);
  }

  void updatepastHistoryData(Map<String, dynamic> value) {
    state = state.copyWith(pastHistoryData: value);
  }

  void updatePhNo(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateNewappointmentCheifComplaint(String? value) {
    state = state.copyWith(cheifComplaint: value);
  }

  void updateNewappointmentPersonalHistory(String value) {
    state = state.copyWith(personalHistory: value);
  }

  void updateNewappointmentPastHistory(String value) {
    state = state.copyWith(pastHistory: value);
  }

  void updateAppointmentList(List<dynamic> value) {
    state = state.copyWith(appointments: value);
  }

  void updateIsFetchingPersonalInfo(bool value) {
    state = state.copyWith(isFetchingPersonalInfo: value);
  }

  void updateIsFetchingNewAptInfo(bool value) {
    state = state.copyWith(isFetchingNewAptInfo: value);
  }

  void updateIsFetchingAptList(bool value) {
    state = state.copyWith(isFetchingAptList: value);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  Future<void> fetchAppointmentList(BuildContext context, int patientId) async {
    updateIsFetchingAptList(true);
    updateErrorOccurs(false);

    try {
      Map<String, dynamic> response = await PatientService.getAptDetails(
        context,
        mounted,
        patientId,
      );
      debugPrint('response of apt details $response');
      List<AppointmentDetails> appointmentList =
          (response[ApiKeyEnum.appointmentTimeDetailsList.key] as List<dynamic>).map((
            appointment,
          ) {

            debugPrint(appointment[ApiKeyEnum.consultationStatus.key]);
            return AppointmentDetails(
              patientId: appointment[ApiKeyEnum.patientId.key] as int,
              appointmentId: appointment[ApiKeyEnum.appointmentTimeId.key] as int,
              slotId: appointment[ApiKeyEnum.slotId.key] as int,
              startTime: appointment[ApiKeyEnum.startTime.key],
              endTime: appointment[ApiKeyEnum.endTime.key],
              chiefComplaint: appointment[ApiKeyEnum.chiefComplaint.key],
              appointmentType: appointment[ApiKeyEnum.appointmentType.key],
              appointmentStatus: appointment[ApiKeyEnum.consultationStatus.key],
            );
          }).toList();
      updatePatientName(response[ApiKeyEnum.patientName.key]);
      updateAppointmentList(appointmentList);
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error.toString());
    } finally {
      updateIsFetchingAptList(false);
    }

  }

  Future<void> fetchPersonalInfo(BuildContext context, int patientId) async {
    updateIsFetchingPersonalInfo(true);

    try {
      Map<String, dynamic> response = await PatientService.getPersonalInfo(
        context,
        mounted,
        patientId,
      );
      debugPrint('response of personal details $response');
      if (!response.containsKey(ApiKeyEnum.status.key)) {
        updatepersonalData(response);

        updateGender(response[ApiKeyEnum.gender.key]);
        updatePhNo(response[ApiKeyEnum.mobileNumber.key]);
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
    } finally {
      updateIsFetchingPersonalInfo(false);
    }
  }

  Future<dynamic> fetchPastHistoryInfo(
    BuildContext context,
    int patientId,
  ) async {
    updateIsFetchingNewAptInfo(true);

    try {
      Map<String, dynamic> response = await PatientService.getPastHistoryInfo(
        context,
        mounted,
        patientId,
      );
      debugPrint('response of past details $response');
      if (!response.containsKey(ApiKeyEnum.status.key)) {
        updateNewappointmentCheifComplaint(response[ApiKeyEnum.chiefComplaint.key]);
        updatepastHistoryData(response);

        if (response[ApiKeyEnum.pastHistory.key] == null) {
          updateNewappointmentPastHistory(Strings.hasntText);
        } else {
          bool hasPastHistory =
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.diabetesMellitus.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.hypertension.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.bronchialAsthma.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.seizureDisorder.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.coronaryArteryDisease.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.cerebrovascularDisease.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.tuberculosis.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.headInjury.key] ||
              response[ApiKeyEnum.pastHistory.key][ApiKeyEnum.anySurgery.key];
          updateNewappointmentPastHistory(hasPastHistory ? Strings.hasText : Strings.hasntText);
        }
        bool hasPersonalHistory =
            response[ApiKeyEnum.alcoholUse.key] ||
            response[ApiKeyEnum.nicotineUse.key] ||
            response[ApiKeyEnum.otherSubstance.key];
        updateNewappointmentPersonalHistory(
          hasPersonalHistory ? Strings.hasText : Strings.hasntText,
        );
      } else {
        updateNewappointmentCheifComplaint(Strings.nodataFound);

        updateNewappointmentPersonalHistory(Strings.nodataFound);
        updateNewappointmentPastHistory(Strings.nodataFound);
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
    } finally {
      updateIsFetchingNewAptInfo(false);
    }
  }

  void onMenuOptionSelected(
    int patientId,
    String option,
    BuildContext context,
    String patientName,
  ) {
    switch (option) {
      case Strings.patientProfileEditpopupMenuValue:
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (context) => EditPatientDetailsView(
                      patientId: patientId,
                      personalData: state.personalData,
                      pastHistoryData: state.pastHistoryData,
                    ),
              ),
            )
            .then((_) {
              initialize(context, patientId, patientName);
            });
        break;
    }
  }

}

final patientProfileViewModelProvider =
    StateNotifierProvider<PatientProfileViewModel, PatientProfile>((ref) {
      return PatientProfileViewModel();
    });
