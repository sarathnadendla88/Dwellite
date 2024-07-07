import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderView {
  static LoaderView? _instance;

  LoaderView._();

  factory LoaderView() => _instance ??= LoaderView._();

  late BuildContext _dialogContext; // To store the context of the dialog
  late bool _isDialogShowing; // Track if dialog is currently shown

  void pleaseWaitDialog(BuildContext context) {
    _isDialogShowing = true; // Mark dialog as showing

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        _dialogContext = context; // Store the context of the dialog
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  color: Colors.blue, // Customize based on your app's theme
                  radius: 15,
                ),
                SizedBox(width: 20.0),
                Text(
                  'Please wait...',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void cancelDialog() {
    if (_isDialogShowing) {
      Navigator.of(_dialogContext).pop(); // Dismiss the dialog using its context
      _isDialogShowing = false; // Mark dialog as dismissed
    }
  }
}

