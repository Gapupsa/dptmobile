import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CameraPage extends StatefulWidget {

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
 
    return Column(
      
    );
  }

}