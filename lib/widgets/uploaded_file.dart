import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class UploadedFileDisplay extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback? onDelete;
  final bool isEditMode;

   const UploadedFileDisplay({super.key, required this.file, this.onDelete,required this.isEditMode});

  static const int maxFileSize = 10 * 1024 * 1024; 

  @override
  Widget build(BuildContext context) {
    bool isFileTooLarge = file.size > maxFileSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          Strings.fileUploadText,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isFileTooLarge
                      ? Theme.of(context).colorScheme.error.withOpacity(0.5)
                      : Theme.of(context).colorScheme.tertiary,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      file.extension == Strings.allowedExtensionsPdfText
                          ? Icons.picture_as_pdf
                          : Icons.photo_rounded,
                      color:
                          isFileTooLarge
                              ? Theme.of(context).colorScheme.error.withOpacity(
                                0.5,
                              ) 
                              : file.extension == Strings.allowedExtensionsPdfText
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          return Text(
                            file.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color:
                                  isFileTooLarge
                                      ? Theme.of(context).colorScheme.onSurface
                                          .withOpacity(0.5) 
                                      : Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.color,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(!isEditMode)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: onDelete,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    radius: 12,
                    child: Icon(
                      Icons.delete_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isFileTooLarge) 
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
            ), 
            child: Text(
              Strings.fileSizeErrMsg,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
