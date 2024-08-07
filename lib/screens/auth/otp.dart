import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/loader_view.dart';
import 'package:dwellite/utils/toast_helper.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:dwellite/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 10);
  final TextEditingController otpController = TextEditingController();
  final APIService _apiService = APIService.instance;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // startTimer();
    _getId();
  }

  String? deviceId = "";
  Future<void> _getId() async {
    var otpData = await SharedPreferencesHelper().readData("otp");
    // otpController.text = otpData;
    ToastHelper().showLongToast(otpData.toString());
    try {
      deviceId = await Utils().getId();
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error obtaining device ID: $e');
    }
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 2));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(
        () {
          final seconds = myDuration.inSeconds - reduceSecondsBy;
          if (seconds < 0) {
            countdownTimer!.cancel();
          } else {
            myDuration = Duration(seconds: seconds);
          }
        },
      );
    }
  }

  Future<void> verifyOtp() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));
    String userid = await SharedPreferencesHelper().readData('localuserid');
    Response<dynamic> res = await _apiService.verifyOtp(
      int.parse(userid),
      otpController.text,
      deviceId!,
    );
    LoaderView().cancelDialog();
    if (res.statusCode == 200) {
      var data = res.data['data'];
      print(data);
      if (data['access_token'] != null) {
        // to save token in local storage
        SharedPreferencesHelper()
            .saveData('useraccesstoken', data['access_token']);

        SharedPreferencesHelper()
            .saveIntData(Constants.ISADMIN, data['is_admin']);
        SharedPreferencesHelper()
            .saveIntData(Constants.ISVERIFIED, data['is_verified']);
        SharedPreferencesHelper().saveData(Constants.USERNAME, data['name']);
        Constants.USERNAMECONST = data['name'];
        SharedPreferencesHelper().saveData(Constants.USEREMAIL, data['email']);
        if (data['email'] != null) {
          Constants.USEREMAILCONST = data['email'] ?? "";
        }
        // stopTimer();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.popAndPushNamed(context, '/bottomBar');
      }
    } else {
      // stopTimer();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    otpController.text = arguments['loginotp'];
    final size = MediaQuery.of(context).size;
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/auth/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSpace,
            height5Space,
            height5Space,
            height5Space,
            backbutton(context),
            height5Space,
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                children: [
                  otpText(),
                  heightSpace,
                  pleaseText(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  height5Space,
                  otpField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  height5Space,
                  timer(minutes, seconds),
                  heightSpace,
                  heightSpace,
                  height5Space,
                  verifyButton(),
                  heightSpace,
                  resendText(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  resendText() {
    return Text.rich(
      TextSpan(
        text: getTranslate(context, 'otp.didnt_recived'),
        style: medium16Primary,
        children: [
          const TextSpan(text: " "),
          TextSpan(
              text: getTranslate(context, 'otp.resend'),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (myDuration == const Duration(seconds: 0)) {
                    // resetTimer();
                    // startTimer();
                  }
                }),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  verifyButton() {
    return GestureDetector(
      onTap: () {
        if (otpController.text.length > 5) {
          LoaderView().pleaseWaitDialog(context);
          verifyOtp();
        } else if (otpController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Please enter OTP."),
            backgroundColor: Colors.red.shade300,
          ));
        }
        // Timer(const Duration(seconds: 3), () {
        //   stopTimer();
        //   Navigator.popAndPushNamed(context, '/bottomBar');
        // });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslate(context, 'otp.verify'),
          style: semibold18White,
        ),
      ),
    );
  }

  timer(minutes, seconds) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 1.5, vertical: fixPadding / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: const Color(0xFFD6E9F5),
        ),
        child: Text(
          "$minutes:$seconds",
          style: regular16Black,
        ),
      ),
    );
  }

  otpField() {
    return Pinput(
      controller: otpController,
      length: 6,
      cursor: Container(
        height: 22,
        width: 2,
        color: primaryColor,
      ),
      onCompleted: (value) {
        otpController.text = value;
        LoaderView().pleaseWaitDialog(context);
        verifyOtp();

        // Timer(const Duration(seconds: 3), () {
        //   stopTimer();
        //   Navigator.popAndPushNamed(context, '/bottomBar');
        // });

        // pleaseWaitDialog();
      },
      defaultPinTheme: PinTheme(
        height: 50.0,
        width: 50.0,
        margin: const EdgeInsets.symmetric(horizontal: fixPadding / 2),
        textStyle: medium20Black33,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.25),
              blurRadius: 6.0,
            )
          ],
        ),
      ),
    );
  }

  pleaseText() {
    return Text(
      getTranslate(context, 'otp.please_text'),
      textAlign: TextAlign.center,
      style: medium14Grey77,
    );
  }

  otpText() {
    return Text(
      getTranslate(context, 'otp.OTP_VERIFICATION'),
      style: semibold21Primary,
      textAlign: TextAlign.center,
    );
  }

  backbutton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      padding: const EdgeInsets.all(fixPadding * 2.0),
      icon: const Icon(
        Icons.arrow_back,
        color: black33Color,
      ),
    );
  }
}
