import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ImgPicker extends StatefulWidget {
  final void Function(File files) imagePickFn;
  ImgPicker(this.imagePickFn);
  @override
  _ImgPickerState createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  File _files;

  Future<void> selectImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );
    if (result != null) {
      setState(() {
        _files = File(result.files.single.path);
      });
    }
    widget.imagePickFn(_files);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (_files != null)
            Container(
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) => Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(10),
                  child: Image(
                    image: FileImage(_files),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          FlatButton.icon(
            onPressed: selectImage,
            icon: Icon(Icons.camera_alt),
            label: Text(
              "Select Images",
            ),
          ),
        ],
      ),
    );
  }
}
