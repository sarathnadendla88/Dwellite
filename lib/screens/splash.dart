import 'dart:async';

import 'package:dwellite/notifications/notification_service.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    PushNotifications.getDeviceToken();
    Timer(const Duration(seconds: 3), () async {
      SharedPreferencesHelper()
          .readData('useraccesstoken')
          .then((String atoken) {
        if (atoken.isNotEmpty) {
          Navigator.popAndPushNamed(context, '/bottomBar');
        } else {
          Navigator.pushNamed(context, '/onboarding');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash/bgImage.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleAndLogo(),
                bottomImage(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  titleAndLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        heightBox(fixPadding * 30.0),
        Image.asset(
          "assets/icon.png",
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
        heightSpace,
        const Text(
          "DWELLITE",
          style: semibold28Primary,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.0,
              height: 2,
              color: primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: fixPadding / 2),
              child: Text(
                "Society",
                style: medium18Primary,
              ),
            ),
            Container(
              width: 30.0,
              height: 2,
              color: primaryColor,
            ),
          ],
        )
      ],
    );
  }

  bottomImage(Size size) {
    return Image.asset(
      "assets/splash/image.png",
      height: size.height * 0.2,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  }
}
