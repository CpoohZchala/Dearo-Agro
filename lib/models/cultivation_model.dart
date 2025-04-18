class Cultivation {
  final String memberId;
  final String cropCategory;
  final String cropName;
  final String address;
  final String startDate;
  final String district;
  final String city;
  final String? id;

  Cultivation({
    required this.memberId,
    required this.cropCategory,
    required this.cropName,
    required this.address,
    required this.startDate,
    required this.district,
    required this.city,
    this.id,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "memberId": memberId,
      "cropCategory": cropCategory,
      "cropName": cropName,
      "address": address,
      "startDate": startDate,
      "district": district,
      "city": city,
    };
    if (id != null) data["id"] = id!;
    return data;
  }

  factory Cultivation.fromJson(Map<String, dynamic> json) {
    return Cultivation(
      id: json['_id'],
      memberId: json['memberId'],
      cropCategory: json['cropCategory'],
      cropName: json['cropName'],
      address: json['address'],
      startDate: json['startDate'],
      district: json['district'],
      city: json['city'],
    );
  }
}
