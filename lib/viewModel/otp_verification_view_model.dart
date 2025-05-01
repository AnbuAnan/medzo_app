// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/otp_verification.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/identity_verification_view.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:path_provider/path_provider.dart';

class OtpVerificationViewModel extends StateNotifier<OtpVerification> {
  Timer? _timer;

  OtpVerificationViewModel()
    : super(
        OtpVerification(
          formKey: GlobalKey<FormState>(),
          otpKey: GlobalKey<OtpPinFieldState>(),
          mismtachError: false,
          isResendButtonDisabled: false,
          counter: 30,
          otp: null,
          isVerifying: false,
        ),
      );

  void updateMismatchError(bool value) {
    state = OtpVerification(
      formKey: state.formKey,
      otpKey: state.otpKey,
      mismtachError: value,
      isResendButtonDisabled: state.isResendButtonDisabled,
      counter: state.counter,
      otp: state.otp,
      isVerifying: state.isVerifying,
    );
  }

  void updateIsResendButtonDisabled(bool value) {
    state = OtpVerification(
      formKey: state.formKey,
      otpKey: state.otpKey,
      mismtachError: state.mismtachError,
      isResendButtonDisabled: value,
      counter: state.counter,
      otp: state.otp,
      isVerifying: state.isVerifying,
    );
  }

  void updateCounter(int value) {
    state = OtpVerification(
      formKey: state.formKey,
      otpKey: state.otpKey,
      mismtachError: state.mismtachError,
      isResendButtonDisabled: state.isResendButtonDisabled,
      counter: value,
      otp: state.otp,
      isVerifying: state.isVerifying,
    );
  }

  void updateOtp(dynamic value) {
    state = OtpVerification(
      formKey: state.formKey,
      otpKey: state.otpKey,
      mismtachError: state.mismtachError,
      isResendButtonDisabled: state.isResendButtonDisabled,
      counter: state.counter,
      otp: value,
      isVerifying: state.isVerifying,
    );
  }

  void updateIsVerifying(bool value) {
    state = OtpVerification(
      formKey: state.formKey,
      otpKey: state.otpKey,
      mismtachError: state.mismtachError,
      isResendButtonDisabled: state.isResendButtonDisabled,
      counter: state.counter,
      otp: state.otp,
      isVerifying: value,
    );
  }

  void startTimer() {
    _timer?.cancel();

    updateIsResendButtonDisabled(true);
    updateCounter(30);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.counter > 0) {
        updateCounter(state.counter - 1);
      } else {
        _timer?.cancel();
        updateIsResendButtonDisabled(false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> resendOtp(BuildContext context, String phNo) async {
    if (!state.isResendButtonDisabled) {
      state.otpKey.currentState!.clearOtp();
      startTimer();

      await AuthenticationService.verifyPhoneNumber(context, mounted, phNo);
    }
  }

  Future<void> verifyingOtp(
    String phNo,
    BuildContext context,
    Function authCall,
    Function saveProfile,
  ) async {
    updateMismatchError(false);
    updateIsVerifying(true);

    try {
      var response = await AuthenticationService.verifyOtp(
        context,
        mounted,
        phNo,
        state.otp!,
      );
      if (response[ApiKeyEnum.status.key].toLowerCase() == Strings.falseLowerCaseTxt) {
        updateMismatchError(true);
        updateIsVerifying(false);
      } else if (response[ApiKeyEnum.status.key].toString().toLowerCase() == Strings.activeText ||
          response[ApiKeyEnum.status.key].toString().toLowerCase() == Strings.inActiveText) {
        fetchProfilePic(context, response[ApiKeyEnum.doctorId.key], saveProfile);
        await authCall(UserType.doctor, response);
        Future.delayed(Duration(seconds: 1), () {
          updateIsVerifying(false);
          state.otpKey.currentState!.clearOtp();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const IdentityVerificationView(),
          ),
        );
      }
    } catch (e) {
      updateIsVerifying(false);
    }
  }

  Future<void> fetchProfilePic(
    BuildContext context,
    int? doctorId,
    Function saveProfile,
  ) async {
    debugPrint('profile pic function doctorID $doctorId');
    try {
      var profilePicPredefinedURL =
          await AuthenticationService.getPredefinedURL(
            context,
            mounted,
            '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.profilePic.key}',
            false,
          );

      if (profilePicPredefinedURL != null) {
        debugPrint(profilePicPredefinedURL);
        downloadAndSavePDF(
          context,
          profilePicPredefinedURL,
          Strings.doctorProfileFileName,
          saveProfile,
        );
      }
    } catch (e) {
      debugPrint('error on fetch thr profile picture ===== $e');
    }
  }

  Future<void> downloadAndSavePDF(
    BuildContext context,
    pdfUrl,
    filname,
    Function saveProfile,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$filname";
      debugPrint('Download the file using http');

      final response = await apiService.getFileByURL(pdfUrl);
      if (response.statusCode == 200) {
        final file = File(filePath);
        final profilePic = await file.writeAsBytes(response);
      
        saveProfile(profilePic);
      } else {
        saveProfile(null);
        throw Exception(Strings.failedToDownload);
      }
    } catch (e) {
      debugPrint("Error downloading file: $e");
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text("Failed to load file")));
    }
  }
}

final otpVerificationViewModelProvider =
    StateNotifierProvider<OtpVerificationViewModel, OtpVerification>((ref) {
      return OtpVerificationViewModel();
    });
