import 'dart:io';

import 'package:flutter/material.dart';

class UserProfile {
  final GlobalKey<FormState> formKey;
  final TextEditingController userNameController;
  final TextEditingController phNumberController;
  final TextEditingController emailController;
  final bool? isKycUploaded;
  final String? profilePicPath;
  final File? profilePic;
  final bool isLoading;
  final File? license;
  final String? licensepath;
  final File? profileImage;
  final String? profileImagePath;
  final bool? isEditable;
  final bool licenseError;
  final bool profileError;
  final bool isEmailValidate;
  final bool isEmailOnchanged;
  final String userEmail;
  final int licenseUniqueKey;
  final int profileUniqueKey;

  UserProfile({
    required this.formKey,
    required this.userNameController,
    required this.phNumberController,
    required this.emailController,
    required this.isLoading,
    this.profileImage,
    this.profileImagePath,
    this.license,
    this.licensepath,
    this.isKycUploaded,
    this.profilePicPath,
    this.profilePic,
    this.isEditable,
    required this.licenseError,
    required this.profileError,
    required this.licenseUniqueKey,
    required this.profileUniqueKey,
    required this.isEmailOnchanged,
    required this.isEmailValidate,
    required this.userEmail,
  });

  UserProfile copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? userNameController,
    TextEditingController? phNumberController,
    TextEditingController? emailController,
    bool? isKycUploaded,
    bool? isLoading,
    String? profilePicPath,
    File? profilePic,
    File? profileImage,
    String? profileImagePath,
    File? license,
    String? licensepath,
    bool? isEditable,
    bool? licenseError,
    bool? profileError,
    int? licenseUniqueKey,
    int? profileUniqueKey,
    bool? isEmailOnchanged,
    bool? isEmailValidate,
    String? userEmail,
  }) {
    return UserProfile(
      formKey: formKey ?? this.formKey,
      userNameController: userNameController ?? this.userNameController,
      phNumberController: phNumberController ?? this.phNumberController,
      emailController: emailController ?? this.emailController,
      isKycUploaded: isKycUploaded ?? this.isKycUploaded,
      isEditable: isEditable ?? this.isEditable,
      isLoading: isLoading ?? this.isLoading,
      license: license ?? this.license,
      licensepath: licensepath ?? this.licensepath,
      profilePic: profilePic ?? this.profilePic,
      profilePicPath: profilePicPath ?? this.profilePicPath, //its a dp
      profileImage: profileImage ?? this.profileImage,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      licenseError: licenseError ?? this.licenseError,
      profileError: profileError ?? this.profileError,
      profileUniqueKey: profileUniqueKey ?? this.profileUniqueKey,
      licenseUniqueKey: licenseUniqueKey ?? this.licenseUniqueKey,
      isEmailOnchanged: isEmailOnchanged ?? this.isEmailOnchanged,
      isEmailValidate: isEmailValidate ?? this.isEmailValidate,
      userEmail:  userEmail ?? this.userEmail,
    );
  }
}
