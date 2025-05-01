// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/user_profile_view_model.dart';
import 'package:open_file/open_file.dart';

class UploadFieldWithProgress extends ConsumerStatefulWidget {
  final String title;
  final bool error;
  final Function(bool)? onUploadCompleted;
  final File? file;
  final int doctorId;

  const UploadFieldWithProgress({
    super.key,
    required this.title,
    required this.onUploadCompleted,
    required this.doctorId,
    required this.error,
    this.file,
  });

  @override
  UploadFieldWithProgressState createState() => UploadFieldWithProgressState();
}

class UploadFieldWithProgressState
    extends ConsumerState<UploadFieldWithProgress> {
  bool fileUploadError = false;
  double _uploadProgress = 0.0;
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  String _uploadState = "idle"; 
  String? _errorMessage;
  bool skipUpload = false;

  static const int maxFileSize = 10 * 1024 * 1024; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.file != null) {
      if (mounted) {
        setState(() {
          skipUpload = true;
          _uploadState = Strings.ufcompletedText;
          _handlePickedFile(Strings.emptySpace, widget.file!.path, widget.file!.lengthSync());
        });
      }
    }

    if (widget.file == null) {
      setState(() {
        _uploadState = Strings.ufidleText;
      });
    }

    if (widget.error) {
      setState(() {
        _uploadState = Strings.ufdowloadFailedText;
      });
    }
  }

  String _getFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} ${Strings.kbFileSize}';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} ${Strings.mbFileSize}';
    }
  }

  Future<void> _pickFile() async {
    if (mounted) {
      setState(() {
        skipUpload = false;
      });
    }

    FilePickerResult? result;

    if (widget.title == Strings.userProfileKycUploadFieldLicenseTitle) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: Strings.allowedExtensionsPdf,
      );

      if (result != null) {
        _handlePickedFile(
          Strings.licenseFileName,
          result.files.single.path,
          result.files.single.size,
        );
        File licenseFile = File(result.files.single.path!);
        Uint8List licenseFileBytes = await licenseFile.readAsBytes();
        if (result.files.single.size <= maxFileSize) {
          try {
            var licensePredefinedURL =
                await AuthenticationService.getPredefinedURL(
                  context,
                  mounted,
                  '${ApiKeyEnum.doctorId.key}${Strings.hypenText}${widget.doctorId}${Strings.hypenText}${ApiKeyEnum.license.key}',
                  true,
                );
            debugPrint('uploading licence url ==== $licensePredefinedURL');

            int licenseResponse = await AuthenticationService.uploadFile(
              context,
              mounted,
              licensePredefinedURL,
              licenseFileBytes,
            );

            if (licenseResponse == 200) {
              if (mounted) {
                await ref
                    .read(userProfileProvider.notifier)
                    .getDoctorLicense(context, widget.doctorId);
              }
            } else {
              if (mounted) {
                setState(() {
                  _uploadState = Strings.uffailedText;
                  fileUploadError = true;
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(Strings.ufFailedToUploadFileText)),
              );
            }
          } catch (e) {
            setState(() {
              _uploadState = Strings.uffailedText;
              fileUploadError = true;
            });

            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(Strings.ufFailedToUploadFileText)),
            );
          }
        }
      }
    } else if (widget.title == Strings.userProfileKycUploadFieldProfileTitle) {
      FilePickerResult? imageFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: Strings.allowedExtensionsImg,
      );
      if (imageFile != null && imageFile.files.single.size <= maxFileSize) {
        _handlePickedFile(
          Strings.profileFileName,
          imageFile.files.single.path,
          imageFile.files.single.size,
        );
        File profileFile = File(imageFile.files.single.path!);
        Uint8List profileFileBytes = await profileFile.readAsBytes();
        try {
          var profilePredefinedURL =
              await AuthenticationService.getPredefinedURL(
                context,
                mounted,
                '${ApiKeyEnum.doctorId.key}${Strings.hypenText}${widget.doctorId}${Strings.hypenText}${ApiKeyEnum.profile.key}',
                true,
              );
          debugPrint(
            ' uploading profile images url ==== $profilePredefinedURL',
          );

          int profileResponse = await AuthenticationService.uploadFile(
            context,
            mounted,
            profilePredefinedURL,
            profileFileBytes,
          );
          debugPrint("response for upload: $profileResponse");

          if (profileResponse == 200) {
            if (mounted) {
              await ref
                  .read(userProfileProvider.notifier)
                  .getDoctorProfileImage(context, widget.doctorId);
            }
          } else {
            if (mounted) {
              setState(() {
                _uploadState = "failed";
                fileUploadError = true;
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(Strings.ufFailedToUploadFileText)),
            );
          }
        } catch (e) {
          setState(() {
            _uploadState = Strings.uffailedText;
            fileUploadError = true;
          });
          debugPrint('Failed to upload $e');
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(Strings.ufFailedToUploadFileText)),
          );
        }
      }
    }
  }

  void _handlePickedFile(String? fileName, String? path, int size) {
    setState(() {

      _fileSize = size;
      if (_fileSize! > maxFileSize) {
        _errorMessage = Strings.userProfileMaxFileSizeErrText;
        _fileName = null;
        _filePath = null;
        _uploadState = Strings.ufidleText;
        _uploadProgress = 0.0;
      } else {
        debugPrint(fileName);
        debugPrint(path);
        _fileName =
            fileName!.isEmpty
                ? path?.split(Strings.forwardSlashSymbol).last
                : '$fileName.${path!.split(Strings.dotSymbol).last}';
        _filePath = path;
        if (!skipUpload) {
          _uploadState = Strings.ufUploadingText;
          _uploadProgress = 0.0;
          _errorMessage = null; 
          _simulateUpload();
        }
      }
    });
  }

  void _simulateUpload() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          if (_uploadProgress >= 1) {
            _uploadProgress = 1.0;
            _uploadState = Strings.ufcompletedText;
            widget.onUploadCompleted?.call(true);
          } else if (_uploadState ==  Strings.ufUploadingText) {
            _uploadProgress += 0.1;
            _uploadProgress = _uploadProgress.clamp(0.0, 1.0);
            _simulateUpload();
          }
        });
      }
    });
  }

  void _viewFile() {
    if (_filePath != null) {
      OpenFile.open(_filePath); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _uploadState ==  Strings.ufcompletedText ? _viewFile : _pickFile,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                _uploadState ==  Strings.ufidleText
                    ? Colors.red.shade400
                    : _uploadState ==  Strings.ufUploadingText
                    ? Colors.blue.shade300
                    : _uploadState ==  Strings.uffailedText
                    ? Colors.red.shade300
                    : const Color.fromARGB(255, 202, 202, 202),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_uploadState ==  Strings.ufidleText) ...[
              _buildIdleState(),
            ] else if (_uploadState ==  Strings.ufUploadingText) ...[
              _buildUploadingState(),
            ] else if (_uploadState ==  Strings.uffailedText) ...[
              _buildFailedState(),
            ] else if (_uploadState == Strings.ufdowloadFailedText) ...[
              _buildFailedDowloadState(),
            ] else if (_uploadState ==  Strings.ufcompletedText) ...[
              _buildCompletedState(),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIdleState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.bodySmall),
        Text(
          Strings.userProfileClickToUploadText,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.red,
            decoration: TextDecoration.underline,
            decorationColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _fileName ?? Strings.userProfileKycUploaingText,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _uploadProgress, 
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.blue,
          ), 
        ),
        const SizedBox(height: 8),
        Text(
          "${(_uploadProgress * 100).toStringAsFixed(0)}${Strings.percentangeSymbol}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFailedState() {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.userProfileKycUploadFailedText,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Strings.userProfilePleaseTryAgainText,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _pickFile,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(Strings.userProfileTryAgainText),
        ),
      ],
    );
  }

  Widget _buildFailedDowloadState() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Strings.userProfileKycDownloadFailedText,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.red),
        ),
        TextButton(
          onPressed: () async {
            final action = ref.read(userProfileProvider.notifier);
            if (widget.title == Strings.userProfileKycUploadFieldProfileTitle) {
              if (action.mounted) {
                await action.getDoctorProfileImage(context, widget.doctorId);
              }
            } else {
              await action.getDoctorLicense(context, widget.doctorId);
            }
          },
          child: Text(
            Strings.userProfileTryAgainText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.title == Strings.userProfileKycUploadFieldProfileTitle
                    ? Icons.photo_rounded
                    : Icons.picture_as_pdf_rounded,
                color:
                    widget.title == Strings.userProfileKycUploadFieldProfileTitle
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileName ?? Strings.userProfileFileUploadedText,
                      overflow:
                          TextOverflow
                              .ellipsis, 
                      softWrap: false,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _fileSize != null
                          ? _getFileSize(_fileSize!)
                          : Strings.userProfileUnknownSizeText,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _viewFile,
                      child: Text(
                        Strings.userProfileClickToViewText,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.blue,
                        ), 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: _pickFile,
          child: const Icon(Icons.file_upload_outlined),
        ),
      ],
    );
  }
}
