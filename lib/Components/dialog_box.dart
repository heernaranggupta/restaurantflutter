import 'package:flutter/cupertino.dart';

class DialogBox extends StatelessWidget {
  final title;
  bool isError;

  DialogBox({
    @required this.title,
    @required this.isError
});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Icon(
        isError
            ? CupertinoIcons.exclamationmark_circle
            : CupertinoIcons.checkmark_alt_circle,
        color: isError
            ? CupertinoColors.destructiveRed
            : CupertinoColors.activeGreen,
      ),
      content: Container(margin: EdgeInsets.all(10),
          child: Text(title, style: TextStyle(fontSize: 15),)),
      actions: [
        Container(

          child: Center(
            child: CupertinoButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),),
        )
      ],
    );
  }
}
