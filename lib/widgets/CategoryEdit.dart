// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, file_names

import 'package:ingetin/models/category.dart';
import 'package:flutter/material.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;
  final Function categoryCallback;

  CategoryEdit(this.category, this.categoryCallback, {Key? key}) : super(key: key);

  @override
  _CategoryEditState createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    categoryNameController.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 60.0, right: 15, left: 15),
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                controller: categoryNameController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Enter category name';
                  }

                  return null;
                },
                onChanged: (text) => setState(() => errorMessage = ''),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category name',
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () => saveCategory(context),
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

  Future saveCategory(context) async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    widget.category.name = categoryNameController.text;

    await widget.categoryCallback(widget.category);
    Navigator.pop(context);
  }
}
