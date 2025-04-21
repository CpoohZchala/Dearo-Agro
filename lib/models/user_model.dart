class User {
  final String? fullName;
  final String mobileNumber;
  final String password;
  final String? userType;

  User({
    this.fullName,
    required this.mobileNumber,
    required this.password,
    this.userType,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'mobileNumber': mobileNumber,
      'password': password,
    };

    if (fullName != null) data['fullName'] = fullName!;
    if (userType != null) data['userType'] = userType!;

    return data;
  }
}
