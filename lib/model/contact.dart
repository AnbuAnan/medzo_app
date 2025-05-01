class Contact {
  final String? supportEmail;
  final String? supportPhoneNumber;
  final bool isFetched;

  Contact(
      { this.supportEmail,
       this.supportPhoneNumber,
      required this.isFetched});

  Contact copyWith({
    String? supportEmail,
    String? supportPhoneNumber,
    bool? isFetched,
  }) {
    return Contact(
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhoneNumber: supportPhoneNumber ?? this.supportPhoneNumber,
      isFetched: isFetched ?? this.isFetched,
    );
  }
}
