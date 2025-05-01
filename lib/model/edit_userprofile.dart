class EditUserprofile {
  final String imagePath;
  final bool isLoading;

  EditUserprofile({
  required this.imagePath,
  required this.isLoading,
  });

  EditUserprofile copyWith({
    String? imagePath,
    bool? isLoading
    }) {
    return EditUserprofile(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
