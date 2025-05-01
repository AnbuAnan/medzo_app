// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/identity_verification.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/view/welcome_view.dart';
import 'package:medzo/viewModel/user_profile_view_model.dart';

class IdentityVerificationViewModel
    extends StateNotifier<IdentityVerification> {
  IdentityVerificationViewModel()
    : super(
        IdentityVerification(
          license: null,
          profile: null,
          licenseErrorText: null,
          profileErrorText: null,
          isVerifying: false,
        ),
      );

  void updateLicense(PlatformFile? file) {
    state = IdentityVerification(
      license: file,
      profile: state.profile,
      licenseErrorText: file == null ? null : state.licenseErrorText,
      profileErrorText: state.profileErrorText,
      isVerifying: state.isVerifying,
    );
  }

  void updateProfile(PlatformFile? file) {
    state = IdentityVerification(
      license: state.license,
      profile: file,
      licenseErrorText: state.licenseErrorText,
      profileErrorText: file == null ? null : state.profileErrorText,
      isVerifying: state.isVerifying,
      
    );
  }

  void updateLicenseErrorText(String? text) {
    state = IdentityVerification(
      license: state.license,
      profile: state.profile,
      licenseErrorText: text,
      profileErrorText: state.profileErrorText,
      isVerifying: state.isVerifying,
    );
  }

  void updateProfileErrorText(String? text) {
    state = IdentityVerification(
      license: state.license,
      profile: state.profile,
      licenseErrorText: state.licenseErrorText,
      isVerifying: state.isVerifying,
      profileErrorText: text,
    );
  }

  void updateIsVerifying(bool value) {
    state = IdentityVerification(
      license: state.license,
      profile: state.profile,
      licenseErrorText: state.licenseErrorText,
      profileErrorText: state.profileErrorText,
      isVerifying: value,
    );
  }

  pickLicense() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions:Strings.allowedExtensionsPdf,
    );
    if (resultFile != null) {
    
      updateLicenseErrorText(null);
      updateLicense(resultFile.files.single);
    }
  }

  pickProfile() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: Strings.allowedExtensionsImg,
    );

    if (resultFile != null) {
      PlatformFile file = resultFile.files.single;
      updateProfileErrorText(null);
      updateProfile(file);
    }
   
  }

  Future<void> verifyDocument(
    BuildContext context,
    int doctorId,
    WidgetRef ref,
  ) async {
    if (state.license == null && state.profile == null) {
      updateLicenseErrorText(Strings.identityLicenseErrorMsg);
      updateProfileErrorText(Strings.identityProfileErrorMsg);

      return;
    }

    if (state.license == null) {
      updateLicenseErrorText(Strings.identityLicenseErrorMsg);
      return;
    }

    if (state.profile == null) {
      updateProfileErrorText(Strings.identityProfileErrorMsg);
      return;
    }

    if (state.license != null ||
        state.profile != null &&
        state.license!.size <= 5 * 1024 * 1024 &&
        state.profile!.size <= 2 * 1024 * 1024) {
      updateIsVerifying(true);
      File profileFile = File(state.profile!.path!);
      File licenseFile = File(state.license!.path!);
      Uint8List profileFileBytes = await profileFile.readAsBytes();
      Uint8List licenseFileBytes = await licenseFile.readAsBytes();

      try {
        var licensePredefinedURL = await AuthenticationService.getPredefinedURL(
          context,
          mounted,
          '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.license.key}',
          true,
        );
        debugPrint(licensePredefinedURL);

        int licenseResponse = await AuthenticationService.uploadFile(
          context,
          mounted,
          licensePredefinedURL,
          licenseFileBytes,
        );
        debugPrint("response for upload: $licenseResponse");

        var profilePredefinedURL = await AuthenticationService.getPredefinedURL(
          context,
          mounted,
          '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.profile.key}',
          true,
        );
        debugPrint(profilePredefinedURL);

        int profileResponse = await AuthenticationService.uploadFile(
          context,
          mounted,
          profilePredefinedURL,
          profileFileBytes,
        );
        debugPrint("response for upload: $profileResponse");

        var userDocuments = ref.watch(userProfileProvider.notifier);
        if (licenseResponse == 200) {
          userDocuments.getDoctorLicense(context, doctorId);
        }

        if (profileResponse == 200) {
          userDocuments.getDoctorProfileImage(context, doctorId);
        }

        if (licenseResponse == 200 && profileResponse == 200) {
          updateIsVerifying(false);
          moveToNextPage(context);
        }
      } catch (error) {
        updateIsVerifying(false);
      }

     
    }
  }

  moveToNextPage(context) {
    Future.delayed(const Duration(seconds: 1), () {
      updateLicense(null);
      updateProfile(null);
      updateLicenseErrorText(null);
      updateProfileErrorText(null);
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Welcomeview(duration: 2)),
    );
  }
}

final identityVerificationModelProvider =
    StateNotifierProvider<IdentityVerificationViewModel, IdentityVerification>((
      ref,
    ) {
      return IdentityVerificationViewModel();
    });
