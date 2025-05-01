import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class FileInput extends StatefulWidget {
  const FileInput({
    super.key,
    required this.icon,
    required this.text,
     this.pickFile,
  });

  final IconData icon;
  final String text;
  final void Function(PlatformFile file)? pickFile;

  @override
  State<FileInput> createState() => _FilePickerState();
}

class _FilePickerState extends State<FileInput> {
  PlatformFile? file;

  Future<void> pickFile() async {
    if (widget.text.contains(Strings.uploadFileBtnText)) {
      FilePickerResult? resultFile = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: Strings.allowedExtensionsPdf);
      if (resultFile != null) {
        setState(() {
          file = resultFile.files.first;
        });
        widget.pickFile!(file!);
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        int size = await file.length();

        setState(() {
          this.file = PlatformFile(
            name: pickedFile.name,
            path: pickedFile.path,
            size: size,
          );
        });
        widget.pickFile!(this.file!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), 
        backgroundColor:
            const Color.fromARGB(38, 211, 67, 67), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), 
        ),
      ),
      onPressed: pickFile,
      icon: Icon(
        widget.icon,
        color: Colors.black,
        size: 18,
      ),
      label: Text(
        widget.text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
