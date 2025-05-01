import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/edit_userprofile_view_model.dart';

class EditUserprofileView extends ConsumerStatefulWidget {
  final int? doctorId;
  final int? assistantId;
  final String initialImagePath;

  const EditUserprofileView({
    super.key,
    required this.initialImagePath,
    this.doctorId,
    this.assistantId,
  });

  @override
  EditUserprofileViewState createState() => EditUserprofileViewState();
}

class EditUserprofileViewState extends ConsumerState<EditUserprofileView> {
  @override
  void initState() {
    super.initState();
    debugPrint('${widget.assistantId}');
    debugPrint('${widget.doctorId}');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editUserprofileProvider(widget.initialImagePath));
    final action = ref.read(
      editUserprofileProvider(widget.initialImagePath).notifier,
    );
    final authaction = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            authaction.getProfile();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 54, 47, 228),
            ),
            onPressed: () => _showImageSourceOptions(context, action),
          ),
        ],
      ),
      body: Center(
        child:
            state.isLoading
                ? CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Colors.transparent, 
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        Theme.of(
                          context,
                        ).colorScheme.onPrimary, 
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      strokeWidth: 4, 
                    ),
                  ),
                )
                : state.imagePath.startsWith(Strings.assetsNaviagtionText)
                ? Image.asset(state.imagePath)
                : Image.file(File(state.imagePath)),
      ),
    );
  }

  void _showImageSourceOptions(
    BuildContext context,
    EditUserprofileViewModel action,
  ) {
    final authAction = ref.read(authProvider.notifier);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    Strings.edituserProfileBottomSheetTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await action.pickImageFromCamera(
                              context,
                              widget.doctorId,
                              widget.assistantId,
                              authAction.saveProfile,
                            );
                          },
                        ),
                        Text(
                          Strings.edituserProfileBottomSheetCameraLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library, size: 20),
                          onPressed: () async {
                            Navigator.of(context).pop();

                            await action.pickImageFromGallery(
                              context,
                              widget.doctorId,
                              widget.assistantId,
                              authAction.saveProfile,
                            );
                          },
                        ),
                        Text(
                          Strings.edituserProfileBottomSheetGalleryLabel,

                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
