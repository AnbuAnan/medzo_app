

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserType {
  doctor,
  assistant,
  guest,
}

class SecureStorage {
  // Create an instance of FlutterSecureStorage
  static const _storage = FlutterSecureStorage();

  // Keys
  // static const _authTokenKey = 'authToken';
  static const _userTypeKey = 'userType';
  static const _assistantIdKey = 'assistantId';
  static const _doctorIdKey = 'doctorId';
  static const _userFirstNameKey = 'userFirstName';
  static const _userLastNameKey = 'userLastName';
  static const _userCredentialsKey = 'userCredentials';
  static const _userEmailKey = 'userEmail';
  static const _userPhoneNumberKey = 'userPhoneNumber';
  static const _userSpecialityKey = 'userSpeciality';
  static const _userDesignationKey = 'userDesgination';
  static const _userPasswordKey = 'userPassword';
  static const _userStatusKey = 'userStatus';
  static const _userProfilePicKey = 'userProfilePic';

  // Save Login Details and Auth Token
  static Future<void> saveUserLoginDetails({
    required UserType userType,
    int? assistantId,
    required int doctorId,
    required String userFirstName,
    String? userLastName,
    String? userCredentials,
    required String userEmail,
    required String userPhoneNumber,
    String? userSpeciality,
    String? userDesgination,
    String? userPassword,
    required String userStatus,
    required String userProfilePic,
  }) async {
    await _storage.write(
        key: _userTypeKey, value: userType.name); // Save enum as a string
    await _storage.write(
        key: _assistantIdKey,
        value: assistantId?.toString()); // Save int as a string
    await _storage.write(
        key: _doctorIdKey, value: doctorId.toString()); // Save int as a string
    await _storage.write(key: _userFirstNameKey, value: userFirstName);
    await _storage.write(key: _userLastNameKey, value: userLastName);
    await _storage.write(key: _userCredentialsKey, value: userCredentials);
    await _storage.write(key: _userEmailKey, value: userEmail);
    await _storage.write(key: _userPhoneNumberKey, value: userPhoneNumber);
    await _storage.write(key: _userSpecialityKey, value: userSpeciality);
    await _storage.write(key: _userDesignationKey, value: userDesgination);
    await _storage.write(key: _userPasswordKey, value: userPassword);
    await _storage.write(key: _userStatusKey, value: userStatus);
    await _storage.write(key: _userProfilePicKey, value: userProfilePic);
  }

  // Retrieve Login Details
  static Future<Map<String, dynamic>> getUserLoginDetails() async {
    final userTypeString = await _storage.read(key: _userTypeKey);
    final userType =
        userTypeString != null ? UserType.values.byName(userTypeString) : null;

    final assistantIdString = await _storage.read(key: _assistantIdKey);
    final assistantId =
        assistantIdString != null ? int.tryParse(assistantIdString) : null;

    final doctorIdString = await _storage.read(key: _doctorIdKey);
    final doctorId =
        doctorIdString != null ? int.tryParse(doctorIdString) : null;

    final userFirstName = await _storage.read(key: _userFirstNameKey);
    final userLastName = await _storage.read(key: _userLastNameKey);
    final userCredentials = await _storage.read(key: _userCredentialsKey);
    final userEmail = await _storage.read(key: _userEmailKey);
    final userPhoneNumber = await _storage.read(key: _userPhoneNumberKey);
    final userSpeciality = await _storage.read(key: _userSpecialityKey);
    final userDesignation = await _storage.read(key: _userDesignationKey);
    final userPassword = await _storage.read(key: _userPasswordKey);
    final userStatus = await _storage.read(key: _userStatusKey);
    final userProfilePic = await _storage.read(key: _userProfilePicKey);

    return {
      'userType': userType, // Enum value
      'assistantId': assistantId, // Optional int
      'doctorId': doctorId, // Required int
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userCredentials': userCredentials,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'userSpeciality': userSpeciality,
      'userDesignation': userDesignation,
      'userPassword': userPassword,
      'userStatus': userStatus,
      'userProfilePic': userProfilePic,
    };
  }

  static Future<int?> getDoctorId() async {
    final doctorIdString = await _storage.read(key: _doctorIdKey);
    return doctorIdString != null ? int.tryParse(doctorIdString) : null;
  }

  static Future<bool> isLoggedIn() async {
    // Check if the login details exist in storage
    String? token = await _storage.read(key: _doctorIdKey);
    return token != null;
  }

  // Delete Login Details
  static Future<void> deleteLoginDetails() async {
    await _storage.delete(key: _userTypeKey);
    await _storage.delete(key: _assistantIdKey);
    await _storage.delete(key: _doctorIdKey);
    await _storage.delete(key: _userFirstNameKey);
    await _storage.delete(key: _userLastNameKey);
    await _storage.delete(key: _userCredentialsKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userPhoneNumberKey);
    await _storage.delete(key: _userSpecialityKey);
    await _storage.delete(key: _userDesignationKey);
    await _storage.delete(key: _userPasswordKey);
    await _storage.delete(key: _userStatusKey);
    await _storage.delete(key: _userProfilePicKey);
  }

 
}
