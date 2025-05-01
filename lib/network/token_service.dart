import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/token_store.dart';

Future<void> fetchUserProfile() async {
  try {
    String? token = await tokenStore.read(key: ApiKeyEnum.accesstoken.key);

    final response = await http.get(
      Uri.parse('https://your-api.com/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      await refreshAccessToken();
      await fetchUserProfile(); 
    } else {
      debugPrint('Error fetching profile: ${response.body}');
    }
  } catch (e) {
    debugPrint('Error fetching profile: $e');
  }
}




//refresh access token
Future<void> refreshAccessToken() async {
  try {
    String? refreshToken = await tokenStore.read(key: ApiKeyEnum.refreshtoken.key);

    final response = await http.post(
      Uri.parse('https://your-api.com/refresh'),
      body: jsonEncode({'refresh_token': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await tokenStore.write(key: ApiKeyEnum.accesstoken.key, value: data[ApiKeyEnum.accesstoken.key]);
      await tokenStore.write(key: ApiKeyEnum.refreshtoken.key, value: data[ApiKeyEnum.refreshtoken.key]);
      debugPrint('Access token refreshed!');
    } else {
      debugPrint('Refresh token expired! Logging out.');
      await logout();
    }
  } catch (e) {
    debugPrint('Error refreshing token: $e');
  }
}



//logout
Future<void> logout() async {
  try {
    await tokenStore.delete(key: ApiKeyEnum.accesstoken.key);
    await tokenStore.delete(key: ApiKeyEnum.refreshtoken.key);
    debugPrint('Logged out successfully!');
  } catch (e) {
    debugPrint('Error during logout: $e');
  }
}
