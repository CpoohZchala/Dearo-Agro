class Expense {
  String? id;
  String memberId;
  String addDate;
  String description;
  String expense;

  Expense({
    this.id,
    required this.memberId,
    required this.addDate,
    required this.description,
    required this.expense,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "memberId": memberId,
      "addDate": addDate,
      "description": description,
      "expense": expense,
    };
    if (id != null) data["_id"] = id!;
    return data;
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json["_id"],
      memberId: json["memberId"],
      addDate: json["addDate"],
      description: json["description"],
      expense: json["expense"].toString(),
    );
  }
}
