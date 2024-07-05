import 'dart:async';

import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:flutter/material.dart';

class RingingScreen extends StatefulWidget {
  const RingingScreen({super.key});

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/allowed');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {},

      // WillPopScope(
      //   onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(fixPadding * 2.0),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Image.asset(
                  "assets/ringing/notification.png",
                  height: 54.0,
                  fit: BoxFit.cover,
                ),
              ),
              heightSpace,
              Text(
                getTranslate(context, 'ringing.ringing'),
                style: semibold22Black33,
                textAlign: TextAlign.center,
              ),
              heightSpace,
              Text(
                getTranslate(context, 'ringing.they_are_getting_inform'),
                style: medium16Grey,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
