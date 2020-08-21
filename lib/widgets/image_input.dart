import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectIamge;
  final BuildContext context;
  ImageInput(this.onSelectIamge, this.context);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedIamge;

  Future<void> _pickerSoource() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300],
                              width: 2,
                            ),
                            top: BorderSide(
                              color: Colors.grey[300],
                              width: 2,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.camera),
                            Padding(
                              padding: EdgeInsets.all(4),
                            ),
                            Text('Camera'),
                          ],
                        ),
                      ),
                      onTap: () {
                        _takePicture(true);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300],
                              width: 2,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.image),
                            Padding(
                              padding: EdgeInsets.all(4),
                            ),
                            Text('Gallery'),
                          ],
                        ),
                      ),
                      onTap: () {
                        _takePicture(false);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _takePicture(bool isCamera) async {
    final imagePicked = await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 600,
    );
    final imageFile = File(imagePicked.path);

    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedIamge = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectIamge(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedIamge != null
              ? Image.file(
                  _storedIamge,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'কোনো ছবি দেওয়া হয়নি',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            child: FlatButton.icon(
              icon: Icon(Icons.camera),
              label: Text('ছবি'),
              textColor: Colors.blue,
              onPressed: _pickerSoource,
            ),
          ),
        ),
      ],
    );
  }
}
