class Category {
  int id;
  String name;
  int userId;

  Category({required this.id, required this.name, required this.userId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], userId: json['user_id']);
  }
}
