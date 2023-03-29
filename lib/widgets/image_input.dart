import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({
    Key? key,
    required this.onSelectImage, // Make onSelectImage required
  }) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _storedImage; // Change the type to XFile?
  bool _isTakingPicture = false;

  Future<void> _takePicture() async {
    setState(() {
      _isTakingPicture = true;
    });

    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      setState(() {
        _isTakingPicture = false;
      });
      return;
    }

    setState(() {
      _storedImage = imageFile;
      _isTakingPicture = false;
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: _storedImage != null
            ? Image.file(
                File(_storedImage!.path),// use null-aware operator (!) to assert non-null
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Text('No Image Taken', textAlign: TextAlign.center,),
        alignment: Alignment.center,
      ),

      SizedBox(height:10),

      Expanded(
  child: TextButton.icon(
    icon: Icon(Icons.camera,
    size: 32, ),
    
    label: Text(
      'Take Picture',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20, // Increase the font size of the label
      ),
    ),
      onPressed: _isTakingPicture ? null : () => _takePicture(),
    
  ),
),

    ]);
  }
}
