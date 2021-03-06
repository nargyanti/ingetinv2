// ignore_for_file: file_names, prefer_const_constructors

import 'package:ingetin/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ingetin/models/category.dart';
import 'package:provider/provider.dart';
import 'package:ingetin/providers/CategoryProvider.dart';

class TodoEdit extends StatefulWidget {
  final Todo todo;
  final Function todoCallback;

  TodoEdit(this.todo, this.todoCallback, {Key? key}) : super(key: key);

  @override
  _TodoEditState createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final todoNameController = TextEditingController();
  final todoCategoryController = TextEditingController();
  final todoDescriptionController = TextEditingController();
  final todoDueDateController = TextEditingController();
  final todoDueTimeController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    todoNameController.text = widget.todo.name.toString();
    todoCategoryController.text = widget.todo.categoryId.toString();
    todoDescriptionController.text = widget.todo.description.toString();
    todoDueDateController.text = widget.todo.dueDate.toString();
    todoDueTimeController.text = widget.todo.dueTime.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 50, left: 10, right: 10),
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                controller: todoNameController,            
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',                                    
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Name is required';
                  }                 
                },
                onChanged: (text) => setState(() => errorMessage = ''),
              ),
              ), 
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: buildCategoriesDropdown(),
              ),  
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                controller: todoDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Description is required';
                  }

                  return null;
                },
                onChanged: (text) => setState(() => errorMessage = ''),
              ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                controller: todoDueDateController,
                onTap: () {
                  selectDate(context);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Due date',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Date is required';
                  }

                  return null;
                },
                onChanged: (text) => setState(() => errorMessage = ''),
              ),
              ),     
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: TextFormField(
                controller: todoDueTimeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Time',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Time is required';
                  }
                  return null;
                },
                onChanged: (text) => setState(() => errorMessage = ''),
              ),
              ),                                                                  
              Row(                
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () => saveTodo(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),
              Text(errorMessage, style: TextStyle(color: Colors.red))
            ])));
  }

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5)
    );
    if (picked != null) {
      setState(() {
        todoDueDateController.text = DateFormat('MM/dd/yyyy').format(picked);        
      });
    }
  }

  Widget buildCategoriesDropdown() {
    return Consumer<CategoryProvider>(
      builder: (context, cProvider, child) {
        List<Category> categories = cProvider.categories;

        return DropdownButtonFormField(
          elevation: 8,
          items: categories.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.name,
                    style: TextStyle(color: Colors.black, fontSize: 20.0)));
          }).toList(),
          value: todoCategoryController.text,
          onChanged: (String? newValue) {
            if (newValue == null) {
              return;
            }

            setState(() {
              todoCategoryController.text = newValue.toString();
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Please select category';
            }
          },
        );
      },
    );
  }

  Future saveTodo(context) async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    widget.todo.name = todoNameController.text;
    widget.todo.categoryId = int.parse(todoCategoryController.text);
    widget.todo.description = todoDescriptionController.text;
    widget.todo.dueDate = todoDueDateController.text;
    widget.todo.dueTime = todoDueTimeController.text;

    await widget.todoCallback(widget.todo);
    Navigator.pop(context);
  }
}
