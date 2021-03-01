import 'package:flutter/cupertino.dart';

import 'dialog_box.dart';

showErrorDialog(String title, BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => DialogBox(
      title: title,
      isError: true,
    ),
  );
}
