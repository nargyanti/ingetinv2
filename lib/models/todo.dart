class Todo {
  int id;  
  int categoryId;
  String name;
  String description;
  String dueDate;
  String dueTime;
  String createdAt;
  String updatedAt;

  Todo({
    required this.id,    
    required this.categoryId,      
    required this.name,      
    required this.description,
    required this.dueDate,
    required this.dueTime,    
    required this.createdAt,
    required this.updatedAt
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      name: json['name'],
      categoryId: json['category_id'],
      description: json['description'],
      dueDate: json['due_date'],
      dueTime: json['due_time'],      
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      id: json['id'],   
    );
  }
}
