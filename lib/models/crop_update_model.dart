class CropUpdate {
  String? id;
  String memberId;
  String addDate;
  String description;

  CropUpdate({
    this.id,
    required this.memberId,
    required this.addDate,
    required this.description,
  });

  factory CropUpdate.fromJson(Map<String, dynamic> json) {
    return CropUpdate(
      id: json['_id'],
      memberId: json['memberId'],
      addDate: json['addDate'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'memberId': memberId,
      'addDate': addDate,
      'description': description,
    };
  }
}
