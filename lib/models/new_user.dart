class NewUser {
  String patientId;
  int aadharNumber;
  String name;
  String phoneNumber;
  DateTime dob;
  int age;
  String gender;
  String? refferedPersonName;
  

  NewUser(
      {required this.patientId,
      required this.aadharNumber,
      required this.name,
      required this.phoneNumber,
      required this.dob,
      required this.age,
      required this.gender,
      this.refferedPersonName,
      });
}

List<NewUser> newUsers = [];
