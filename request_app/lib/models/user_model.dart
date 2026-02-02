class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String companyName;
  final String licenseNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.companyName,
    required this.licenseNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'companyName': companyName,
      'licenseNumber': licenseNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      companyName: map['companyName'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
    );
  }
}
