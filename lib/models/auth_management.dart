import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

enum UserType { doctor, assistant, guest }

class AuthStorage {
  static const _authStorage = FlutterSecureStorage();

  static const _userDetails = "userDetails";
  static const _userType = "userType";
  static const _userProfile = "userProfile";

  // Save Login Details and Auth Token
  static Future<void> saveUserLoginDetails({
    required Map<String, dynamic> userDetails,
    required UserType userType,
  }) async {
    await _authStorage.write(
      key: _userDetails,
      value: json.encode(userDetails),
    );
    await _authStorage.write(key: _userType, value: userType.name);
  }

  // Function to save the serialized profile data in storage
  static Future<void> saveProfilePic(fileData) async {
    await _authStorage.write(key: _userProfile, value: json.encode(fileData));
  }

  static Future<Map<String, dynamic>> getUserLoginDetails() async {
    String? jsonUserDetails = await _authStorage.read(key: _userDetails);
    String? jsonUserType = await _authStorage.read(key: _userType);
    dynamic jsonProfilePic = await _authStorage.read(key: _userProfile);

    final userDetails =
        jsonUserDetails != null ? json.decode(jsonUserDetails) : null;
    final userType =
        jsonUserType != null ? UserType.values.byName(jsonUserType) : null;
    final userProfile =
        jsonProfilePic != null ? json.decode(jsonProfilePic) : null;

    return {
      "userDetails": userDetails,
      "userType": userType,
      "userProfile": userProfile,
    };
  }

  static Future<bool> isLoggedIn() async {
    final jsonUserType = await _authStorage.read(key: _userType);
    final userType =
        jsonUserType != null ? UserType.values.byName(jsonUserType) : null;

    if (userType != null) {
      return true;
    }
    return false;
  }

  // Delete Login Details
  static Future<void> deleteLoginDetails() async {
    await _authStorage.delete(key: _userDetails);
    await _authStorage.delete(key: _userType);
    await _authStorage.delete(key: _userProfile);
  }
}

class AuthState {
  final bool isAuthenticated;
  final UserType? userType;
  final Map<String, dynamic>? userDetails;
  final File? profilePic;

  AuthState({
    required this.isAuthenticated,
    this.userType,
    this.userDetails,
    this.profilePic,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
    : super(
        AuthState(
          isAuthenticated: false,
          userType: null,
          userDetails: null,
          profilePic: null,
        ),
      ) {
    checkAuthStatus();
  }

  // Login Method
  Future<void> login(
    UserType userType,
    Map<String, dynamic> authDetails,
  ) async {
    try {
      debugPrint("entered");
      state = AuthState(
        isAuthenticated: true,
        userType: userType,
        userDetails: authDetails,
      );
      debugPrint("half completed");
      await AuthStorage.saveUserLoginDetails(
        userDetails: authDetails,
        userType: userType,
      );
      debugPrint("saved");
    } catch (e) {
      debugPrint("error");
      state = AuthState(isAuthenticated: false);
      rethrow;
    }
  }

  // Function to save the profile
  Future<void> saveProfile(dynamic profile) async {
    
    if (profile != null) {
      String base64File = base64Encode(await profile.readAsBytes());
      await AuthStorage.saveProfilePic({'file': base64File});
    } else {
      throw Exception('Profile is not a valid File object');
    }

    // Update the state with the profile data
    state = AuthState(
      isAuthenticated: state.isAuthenticated,
      userDetails: state.userDetails,
      userType: state.userType,
      profilePic: profile,
    );

  }

  //get the profile pic
  Future<File?> getProfile() async {
    File? profileFile;
    if (state.profilePic != null) {
      debugPrint('user profile not equal to null');
      profileFile = state.profilePic;
    }

    state = AuthState(
      isAuthenticated: state.isAuthenticated,
      userDetails: state.userDetails,
      userType: state.userType,
      profilePic: profileFile,
    );

    debugPrint('${state.profilePic}');
    return state.profilePic;
  }

  // Check Authentication Status
  Future<void> checkAuthStatus() async {
    bool isLoggedIn = await AuthStorage.isLoggedIn();
    if (isLoggedIn) {
      state = AuthState(isAuthenticated: true);
    } else {
      state = AuthState(isAuthenticated: false);
    }
  }

  Future<void> initialize() async {
    final userDetails = await AuthStorage.getUserLoginDetails();

    File? profileFile;
    if (userDetails['userProfile'] != null) {
      final userProfile = userDetails['userProfile'] as Map<String, dynamic>;
      if (userProfile['file'] != null) {
        final decodedBytes = base64Decode(userProfile['file']);
        final directory = await getApplicationDocumentsDirectory();

        final tempFile = File('${directory.path}/DoctorProfile');
        await tempFile.writeAsBytes(decodedBytes);
        profileFile = tempFile;
      }
    }

    if (userDetails['userDetails'] != null) {
      state = AuthState(
        isAuthenticated: true,
        userDetails: userDetails['userDetails'],
        userType: userDetails['userType'],
        profilePic: profileFile,
      );
      debugPrint('user details got it');
    } else {
      state = AuthState(isAuthenticated: false);
    }
  }

  // Logout Method
  Future<void> logout() async {
    await AuthStorage.deleteLoginDetails();
    state = AuthState(isAuthenticated: false);
    debugPrint('${state.isAuthenticated}');
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
