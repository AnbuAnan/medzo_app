import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medzo/util/api_key_enum.dart';

final tokenStore = FlutterSecureStorage();

// Store tokens
Future<void> storeTokens(String accessToken, String refreshToken) async {
  await tokenStore.write(key: ApiKeyEnum.accesstoken.key, value: accessToken);
}

// Retrieve access token
Future<String?> getAccessToken() async {
  return await tokenStore.read(key: ApiKeyEnum.accesstoken.key);
}

// Retrieve refresh token
Future<String?> getRefreshToken() async {
  return await tokenStore.read(key: ApiKeyEnum.refreshtoken.key);
}

// Remove tokens on logout
Future<void> clearTokens() async {
  await tokenStore.delete(key: ApiKeyEnum.accesstoken.key);
  // await tokenStore.delete(key: ApiKeyEnum.refreshtoken.key);
}