import 'package:fume/Widgets/loadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String message;
  const LoadingAlertDialog({required Key key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text(message),
        ],
      ),
    );
  }
}
