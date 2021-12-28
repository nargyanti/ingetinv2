class Todo {
  int id;  
  int categoryId;
  String name;
  String description;
  String dueDate;
  String dueTime;
  int isDone;
  String createdAt;
  String updatedAt;

  Todo({
    required this.id,    
    required this.categoryId,      
    required this.name,      
    required this.description,
    required this.dueDate,
    required this.dueTime,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],      
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      dueDate: json['due_date'],
      dueTime: json['due_time'],
      isDone: json['is_done'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
