class Farmer {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String? password;

  Farmer({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    this.password,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? 'Unnamed Farmer',
      mobileNumber: json['mobileNumber'] ?? 'No mobile number',
      password: json['password'],
    );
  }
}
