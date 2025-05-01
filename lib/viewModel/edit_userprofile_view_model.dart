// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medzo/model/edit_userprofile.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:path_provider/path_provider.dart';

class EditUserprofileViewModel extends StateNotifier<EditUserprofile> {
  final ImagePicker _imagePicker = ImagePicker();

  EditUserprofileViewModel(String initialImagePath, File profilePic)
    : super(EditUserprofile(imagePath: initialImagePath, isLoading: false));

  void updateImagePath(String? value) {
    state = state.copyWith(imagePath: value);
  }

  Future<void> pickImageFromCamera(
    BuildContext context,
    int? doctorId,
    int? assistantId,
    Function saveProfile,
  ) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      await _cropImage(image.path, context, doctorId, assistantId, saveProfile);
    }
  }

  Future<void> pickImageFromGallery(
    BuildContext context,
    int? doctorId,
    int? assistantId,
    Function saveProfile,
  ) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      await _cropImage(image.path, context, doctorId, assistantId, saveProfile);
    }
  }

  Future<void> _cropImage(
    String imagePath,
    BuildContext context,
    int? doctorId,
    int? assistantId,
    Function saveProfile,
  ) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
            showCropGrid: true,
            cropStyle: CropStyle.circle,
            dimmedLayerColor: const Color.fromARGB(175, 0, 0, 0),
            toolbarTitle: Strings.userProfileAppBarTitle,
            toolbarColor: const Color.fromARGB(255, 83, 80, 253),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
            activeControlsWidgetColor: const Color.fromARGB(
              255,
              38,
              31,
              244,
            ), // Locks the aspect ratio to be consistent
          ),
          IOSUiSettings(title: Strings.userProfileAppBarTitle),
        ],
      );
      if (croppedFile != null) {
        updateIsLoading(true);
        _updateImagePath(croppedFile.path); // Update UI instantly

        await _uploadAndFetchProfilePic(
          croppedFile.path,
          context,
          doctorId,
          assistantId,
          saveProfile,
        );
      }
    } catch (e) {
      updateIsLoading(false);
    }
  }

  Future<void> _uploadAndFetchProfilePic(
    String path,
    BuildContext context,
    int? doctorId,
    int? assistantId,
    Function saveProfile,
  ) async {
    try {
      final fileBytes = await File(path).readAsBytes();
      final key =
          doctorId != null
              ? '${ApiKeyEnum.doctorId.key}-$doctorId-${ApiKeyEnum.profilePic.key}'
              : '${ApiKeyEnum.assistantId.key}-$assistantId-${ApiKeyEnum.profilePic.key}';

      final profilePredefinedURL = await AuthenticationService.getPredefinedURL(
        context,
        mounted,
        key,
        true,
      );

      final uploadResponse = await AuthenticationService.uploadFile(
        context,
        mounted,
        profilePredefinedURL,
        fileBytes,
      );

      if (uploadResponse == 200) {
        debugPrint("response for upload: $uploadResponse");
        debugPrint('call fetch function');
        await fetchProfilePic(context, doctorId, assistantId, saveProfile);
      } else {
        updateIsLoading(false);

        throw Exception("${Strings.failedToUpload}$uploadResponse");
      }
    } catch (e) {
      updateIsLoading(false);

      debugPrint('Error during upload and fetch: $e');
    }
  }

  Future<void> fetchProfilePic(
    BuildContext context,
    int? doctorId,
    int? assistantId,
    Function saveProfile,
  ) async {
    final key =
        doctorId != null
            ? '${ApiKeyEnum.doctorId.key}-$doctorId-${ApiKeyEnum.profilePic.key}'
            : '${ApiKeyEnum.assistantId.key}-$assistantId-${ApiKeyEnum.profilePic.key}';
    final fileName =
        doctorId != null
            ? '${Strings.doctorProfileFileName}${Random().nextInt(100)}'
            : '${Strings.assistantProfileFileName}${Random().nextInt(100)}';

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";
      final localFile = File(filePath);

      final profilePicPredefinedURL =
          await AuthenticationService.getPredefinedURL(
            context,
            mounted,
            key,
            false,
          );

      if (profilePicPredefinedURL != null) {
        final response = await apiService.getFileByURL(profilePicPredefinedURL);
        if (response.statusCode == 200) {
          updateIsLoading(false);

          final downloadedFile = await localFile.writeAsBytes(
            response.bodyBytes,
          );

          saveProfile(downloadedFile); // Update state with new file
        } else {
          throw Exception(Strings.failedToDownload);
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile picture: $e');
    }
  }

  void _updateImagePath(String path) {
    state = state.copyWith(imagePath: path);
  }

  void updateIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}

final editUserprofileProvider = StateNotifierProvider.family<
  EditUserprofileViewModel,
  EditUserprofile,
  String
>(
  (ref, initialImagePath) =>
      EditUserprofileViewModel(initialImagePath, File('')),
);
