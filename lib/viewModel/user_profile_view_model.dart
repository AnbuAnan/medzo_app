// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/user_profile.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/network/user_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileViewModel extends StateNotifier<UserProfile> {
  UserProfileViewModel()
    : super(
        UserProfile(
          formKey: GlobalKey<FormState>(),
          userNameController: TextEditingController(),
          phNumberController: TextEditingController(),
          emailController: TextEditingController(),
          profilePic: null,
          profilePicPath: Images.patientProfile,
          license: null,
          licensepath: null,
          profileImage: null,
          profileImagePath: null,
          isEditable: false,
          isLoading: false,
          licenseError: false,
          profileError: false,
          isKycUploaded: false,
          isEmailOnchanged: false,
          isEmailValidate: false,
          profileUniqueKey: 0,
          licenseUniqueKey: 0,
          userEmail: Strings.emptySpace,
        ),
      );

  void updateUserName(String username) {
    state.userNameController.text = username;
  }

  void updateUserPhNumber(String phNo) {
    state.phNumberController.text = phNo;
  }

  void updateUserEmail(String useremail) {
    state.emailController.text = useremail;
  }

  void updateUserEmailValue(String value) {
    state = state.copyWith(userEmail: value);
  }

  void updateLicenseError(bool value) {
    state = state.copyWith(licenseError: value);
  }

  void updateIsEmailOnchanged(bool value) {
    state = state.copyWith(isEmailOnchanged: value);
  }

  void updateIsEmailValidate(bool value) {
    state = state.copyWith(isEmailValidate: value);
  }

  String? validateField(value) {
    if (value == null || value.isEmpty) {
      return Strings.userProfileEmailErrMsgforIsRequired;
    }
    String email = value.toLowerCase();
    if (!email.endsWith(Strings.userProfileEmailCondtion)) {
      return Strings.userProfileEmailErrMsg2;
    }
    return null;
  }

  void updateProfileError(bool value) {
    state = state.copyWith(profileError: value);
  }

  void updateLicencefile(File? file) {
    state = state.copyWith(
      license: file,
      licenseError: state.licenseError,
      licensepath: state.licensepath,
    );
  }

  void updateLicencefilepath(String? filepath) {
    state = state.copyWith(
      licensepath: filepath,
      license: state.license,
      licenseError: state.licenseError,
    );
  }

  void updateImagefile(File? file) {
    state = state.copyWith(
      profileImage: file,
      profileError: state.profileError,
      profileImagePath: state.profileImagePath,
    );
  }

  void updateImagefilepath(String? filepath) {
    state = state.copyWith(
      profileImage: state.profileImage,
      profileError: state.profileError,
      profileImagePath: filepath,
    );
  }

  void updateLicenseUniqueKey(int value) {
    state = state.copyWith(licenseUniqueKey: state.licenseUniqueKey + value);
  }

  void updateProfileUniqueKey(int value) {
    state = state.copyWith(profileUniqueKey: state.profileUniqueKey + value);
  }

  String getFileExtensionFromMime(bytes) {
    String? mimeType = lookupMimeType(Strings.emptySpace, headerBytes: bytes);
    if (mimeType != null) {
      return mimeType.split(Strings.forwardSlashSymbol).last; 
    }
    return Strings.unknownTxt; 
  }

  Future<void> fetchDoctorDetails(
    BuildContext context,
    Map<String, dynamic> doctorDetails,
  ) async {
    updateUserName(
      '${doctorDetails[ApiKeyEnum.firstName.key]} ${doctorDetails[ApiKeyEnum.lastName.key]}',
    );
    updateUserPhNumber('+${doctorDetails[ApiKeyEnum.phone.key]}');
    updateUserEmail(doctorDetails[ApiKeyEnum.email.key]);
    updateUserEmailValue(doctorDetails[ApiKeyEnum.email.key]);
  }

  Future<void> getDoctorLicense(BuildContext context, int doctorId) async {
    try {
      updateLicenseError(false);

      var licencePredefinedURL = await AuthenticationService.getPredefinedURL(
        context,
        mounted,
        '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.license.key}',
        false,
      );

      if (licencePredefinedURL.isNotEmpty) {
        await licenseDownloadAndSavePDF(
          context,
          licencePredefinedURL,
          Strings.licenseFileName,
        );
      }
    } catch (e) {
      String error = e.toString();
      debugPrint('license predefined error $error');
      updateLicenseError(true);
    }
  }

  Future<void> licenseDownloadAndSavePDF(
    BuildContext context,
    String pdfUrl,
    filname,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final response = await apiService.getFileByURL(pdfUrl.trim());
      updateLicenseError(false);
     

      if (response.statusCode == 200) {

        final filetype = getFileExtensionFromMime(response.bodyBytes);
        final filePath = "${directory.path}/$filname.$filetype";
       
        final file = File(filePath);
        final retrivedfile = await file.writeAsBytes(response.bodyBytes);

        updateLicencefilepath(filePath);
        updateLicencefile(retrivedfile);
        updateLicenseUniqueKey(1);
        debugPrint('updated License file --- $retrivedfile');
      } else if (response.statusCode == 404) {
        
        updateLicencefilepath(null);
        updateLicencefile(null);
        updateLicenseError(false);
        updateLicenseUniqueKey(1);
      }
    } catch (e) {
      updateIsLoading(false);
      if (mounted) {
        updateLicenseError(true);
        updateLicenseUniqueKey(1);
      }
    }
  }

  Future<void> getDoctorProfileImage(BuildContext context, int doctorId) async {
    try {
      updateProfileError(false);

      var profileImagePredefinedURL =
          await AuthenticationService.getPredefinedURL(
            context,
            mounted,
            '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.profile.key}',
            false,
          );

      if (profileImagePredefinedURL != null) {
        await profileDownloadAndSavePDF(
          context,
          profileImagePredefinedURL,
          Strings.profileFileName,
        );
      }
    } catch (e) {
      updateProfileError(true);
    }
  }

  Future<void> profileDownloadAndSavePDF(
    BuildContext context,
    pdfUrl,
    filname,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final response = await apiService.getFileByURL(pdfUrl);
     

      updateProfileError(false);
      if (response.statusCode == 200) {
        final filetype = getFileExtensionFromMime(response.bodyBytes);
        final filePath = "${directory.path}/$filname.$filetype";


        final file = File(filePath);
        final retrivedfile = await file.writeAsBytes(response.bodyBytes);
        updateProfileUniqueKey(1);
        updateImagefilepath(filePath);
        updateImagefile(retrivedfile);
        debugPrint("Updated profileImage: ${state.profileImage}");
      } else if (response.statusCode == 404) {
        updateImagefilepath(null);
        updateImagefile(null);
        updateProfileError(false);
        updateProfileUniqueKey(1);
      }
    } catch (e) {
      updateIsLoading(false);
      if (mounted) {
        updateProfileError(true);
        updateProfileUniqueKey(1);
      }

    }
  }

  void updateIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void updateProfilePic(File? file) {
    state = state.copyWith(profilePic: file);
  }

  void updateProfileImage(String newPath) {
    state = state.copyWith(profilePicPath: newPath);
  }

  void handleUploadCompleted(bool isCompleted) {
    state = state.copyWith(isKycUploaded: isCompleted);
  }

  void toggleEditability(
    BuildContext context,
    GlobalKey<FormState> formKey,
    WidgetRef ref,
  ) async {
    if (state.isEditable!) {
      updateIsEmailOnchanged(true);
      if (state.isEmailValidate) {
        final authState = ref.watch(authProvider);
        final userDetails = authState.userDetails ?? {};

        state = state.copyWith(isEditable: false);
        state = state.copyWith(emailController: state.emailController);

        final updatedUserDetails = {
          ...userDetails,
          ApiKeyEnum.email.key : state.emailController.text,
        };
        debugPrint('updated userdetails');

        dynamic response = await UserService.updateDoctorDetails(
          context,
          mounted,
          updatedUserDetails,
        );

        if (response != null) {
          updateUserEmailValue(state.emailController.text);
          debugPrint('successs');
          ref.read(authProvider.notifier).state = AuthState(
            isAuthenticated: authState.isAuthenticated,
            profilePic: authState.profilePic,
            userType: authState.userType,
            userDetails: updatedUserDetails,
          );

          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(Strings.userProfileDetilaUpdatedMsg)),
          );
        } else {
          debugPrint(
            'Error: ${response['error'] ?? 'An unexpected error occurred.'}',
          );
        }
      } else {}
    } else {
      state = state.copyWith(isEditable: true);
    }
  }

  void resetStateOnBack(GlobalKey<FormState> formKey) {
    formKey.currentState?.reset();
    state.emailController.text = state.userEmail;

    state = state.copyWith(isEditable: false);
  }

  bool exitEditModeIfActive() {
    if (state.isEditable!) {
      state = state.copyWith(isEditable: false);
      return true; 
    }
    return false;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileViewModel, UserProfile>(
      (ref) => UserProfileViewModel(),
    );
