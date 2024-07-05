import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderView {
  static LoaderView? _instance;

  LoaderView._();

  factory LoaderView() => _instance ??= LoaderView._();

  pleaseWaitDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: whiteColor,
          insetPadding: const EdgeInsets.all(fixPadding * 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: fixPadding * 2.0, vertical: fixPadding * 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  color: primaryColor,
                  radius: 15,
                ),
                widthSpace,
                Text(
                  getTranslate(context, 'otp.please_wait'),
                  style: semibold18Primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
