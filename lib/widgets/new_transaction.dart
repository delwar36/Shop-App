import 'dart:io';

import 'package:flutter/material.dart';
import '../helpers/upload_image.dart';
import './image_input.dart';
// import 'package:intl/intl.dart';

class Newtransaction extends StatefulWidget {
  final Function addNewTransaction;

  Newtransaction(this.addNewTransaction);

  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _pPriceController = TextEditingController();
  final _sPriceController = TextEditingController();
  final _unitController = TextEditingController();
  // DateTime _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  File _pickedImage;

  void _selectImage(File pickedIamge) {
    _pickedImage = pickedIamge;
  }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmouont = double.parse(_amountController.text);
    final enteredPPrice = double.parse(_pPriceController.text);
    final enteredSPrice = double.parse(_sPriceController.text);
    final enteredUnit = _unitController.text;

    String storageResult;

    if (_formKey.currentState.validate()) {
      try {
        storageResult = await UploadImage.upload(imageToUpload: _pickedImage, imageCategory: 'product');
      } catch (error) {
        print(error.toString());
        throw error;
      }
      if (enteredTitle.isEmpty || storageResult == null) {
        return;
      } else {
        widget.addNewTransaction(
          enteredTitle,
          enteredAmouont,
          enteredPPrice,
          enteredSPrice,
          enteredUnit,
          storageResult,
        );
      }
      _formKey.currentState.save();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            child: formUi(context),
            key: _formKey,
            autovalidate: _autoValidate,
          ),
        ),
      ),
    );
  }

  Column formUi(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ImageInput(_selectImage, context),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'পণ্যের নাম'),
          controller: _titleController,
          validator: (arg) {
            if (arg.length == 0) {
              return 'এই ঘর প্রয়োজনীয়';
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'পরিমাণ'),
          controller: _amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'একক'),
          controller: _unitController,
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'ক্রয়মূল্য(প্রতি একক)'),
          controller: _pPriceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'বিক্রয়মূল্য(প্রতি একক)'),
          controller: _sPriceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('কিনুন'),
          textColor: Theme.of(context).textTheme.button.color,
          onPressed: _submitData,
        ),
      ],
    );
  }
}
