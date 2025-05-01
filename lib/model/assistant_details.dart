class AssistantDetails {
  final int? userId;
  final int? doctorId;
  final String userName;
  final String password;
  final String mobileNumber;
  final String designation;
  final String email;

  AssistantDetails({
    required this.doctorId,
    required this.userId,
    required this.userName,
    required this.password,
    required this.mobileNumber,
    required this.designation,
    required this.email
  });
}