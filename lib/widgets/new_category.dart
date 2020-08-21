import 'dart:io';
import '../helpers/upload_image.dart';


import 'package:flutter/material.dart';
import './image_input.dart';
// import 'package:intl/intl.dart';

class NewCategory extends StatefulWidget {
  final Function addNewCategory;

  NewCategory(this.addNewCategory);

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _titleController = TextEditingController();

  File _pickedImage;

  void _selectImage(File pickedIamge) {
    _pickedImage = pickedIamge;
  }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;

    String storageResult;

    try {
      storageResult = await UploadImage.upload(imageToUpload: _pickedImage, imageCategory: 'category');
    } catch (error) {
      print(error.toString());
      throw error;
    }
    if (enteredTitle.isEmpty || storageResult == null) {
      return;
    } else {
      widget.addNewCategory(enteredTitle, storageResult);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ImageInput(_selectImage, context),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'পণ্যের নাম'),
              controller: _titleController,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('ক্যাটাগরি যোগ করুন'),
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
