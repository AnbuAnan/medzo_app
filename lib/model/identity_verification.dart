import 'package:file_picker/file_picker.dart';

class IdentityVerification {
  final PlatformFile? license;
  final PlatformFile? profile;
  final String? licenseErrorText;
  final String? profileErrorText;
  final bool isVerifying;

  IdentityVerification({
    this.license,
    this.profile,
    this.licenseErrorText,
    this.profileErrorText,
    required this.isVerifying,
  });
}
