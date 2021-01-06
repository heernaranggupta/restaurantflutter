import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CUploadBottomSheet extends StatelessWidget {
  final int imageCount;
  final File choosenFile;
  final Function removeFile;
  final Function chooseImage;

  CUploadBottomSheet(
      {this.chooseImage, this.choosenFile, this.removeFile, this.imageCount});
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            chooseImage(ImageSource.camera, imageCount);
          },
          child: Text('Take Picture'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            chooseImage(ImageSource.gallery, imageCount);
          },
          child: Text('Open Gallery'),
        ),
        if (choosenFile != null)
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              removeFile(imageCount);
            },
            child: Text('Delete Image'),
            isDestructiveAction: true,
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        isDestructiveAction: true,
        child: Text("Cancel"),
      ),
    );
  }
}
