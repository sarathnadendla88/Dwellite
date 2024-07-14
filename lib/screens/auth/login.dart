import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/screens/screens.dart';
//import 'package:dwellite/screens/auth/loginDTO.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/loader_view.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:dwellite/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime? backPressTime;
  final TextEditingController phoneController = TextEditingController();
  String _phoneNumber = '';
  String? _phoneValidationError;
  final APIService _apiService = APIService.instance;
  String? deviceId = "";

  @override
  void initState() {
    super.initState();
    _getId();
  }

  Future<void> _getId() async {
    try {
      deviceId = await Utils().getId();
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error obtaining device ID: $e');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(String value) {
    // Reset error message
    setState(() {
      _phoneValidationError = null;
    });

    // Validate phone number here
    // Example validation: Check if the number has correct length or format
    if (value.isEmpty) {
      setState(() {
        _phoneValidationError = 'Please enter a phone number';
      });
    } else {
      // You can add more sophisticated validation here if needed
      _phoneNumber = value;
    }
  }

  Future<void> login() async {
    LoaderView().pleaseWaitDialog(context);

    Response<dynamic> res =
        await _apiService.login(phoneController.text, deviceId!);

    LoaderView().cancelDialog();
    if (res.statusCode == 200) {
      var data = res.data['data'];
      print(data);

      SharedPreferencesHelper()
          .saveData("localuserid", data['user_id'].toString());
      SharedPreferencesHelper().saveData("otp", data['otp'].toString());
      SharedPreferencesHelper().saveIntData(Constants.USERID, data['user_id']);
      Constants.USERIDCONST = data['user_id'].toString();
      SharedPreferencesHelper().saveIntData(Constants.USER_TYPE_DATA, data['user_type']);

      //SharedPreferencesHelper().saveData("usertype", data['user_type']);
      if (data['user_type'] == UserType.resident.value) {
        userType = UserType.resident;
      } else if (data['user_type'] == UserType.guard.value) {
        userType = UserType.guard;
      } else {
        userType = UserType.resident;
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Navigator.pushNamed(context, '/otp',
          arguments: {'loginotp': data['otp'].toString()});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  void _submitForm() {
    // Validate phone number on button tap
    _validatePhoneNumber(phoneController.text);

    // Check if validation passed
    if (_phoneValidationError == null) {
      // Validation passed, do something with _phoneNumber
      print('Valid phone number: $_phoneNumber');
      login();
    } else {
      // Validation failed, show error message
      setState(() {
        _phoneValidationError = 'Phone number is not valid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/auth/bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(fixPadding * 2.0),
            physics: const BouncingScrollPhysics(),
            children: [
              heightBox(fixPadding * 6),
              loginTitle(),
              heightSpace,
              pleaseText(),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              phoneField(),
              height5Space,
              verificationText(),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              height5Space,
              loginButton(),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              signupText(),
              
              
            ],
          ),
        ),
      ),
    );
  }

  signupText() {
    return Text.rich(
      TextSpan(
        text: getTranslate(context, "Don't have an account?"),
        style: medium16Primary,
        children: [
          const TextSpan(text: " "),
          TextSpan(
              text: getTranslate(context, "Sign up"),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, '/register');
                }),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  loginButton() {
    return GestureDetector(
      onTap: () {
        _submitForm();

        // Navigator.pushNamed(context, '/otp');
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primaryColor,
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
          getTranslate(context, 'login.login'),
          style: semibold18White,
        ),
      ),
    );
  }

  verificationText() {
    return Text(
      getTranslate(context, 'login.verification_text'),
      style: medium14Primary,
    );
  }

  phoneField() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(top: 5),
        child: IntlPhoneField(
          controller: phoneController,
          cursorColor: primaryColor,
          style: semibold16Black33,
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: blackColor,
          ),
          onChanged: (phone) {
            _validatePhoneNumber(phone.completeNumber ?? '');
          },
          textAlign: languageValue == 4 ? TextAlign.right : TextAlign.left,
          flagsButtonPadding:
              const EdgeInsets.symmetric(horizontal: fixPadding * 0.8),
          disableLengthCheck: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: getTranslate(context, 'login.enter_mobile_number'),
            hintStyle: medium16Grey,
            errorText: _phoneValidationError,
          ),
        ),
      ),
    );
  }

  pleaseText() {
    return Text(
      getTranslate(context, 'login.please_text'),
      style: medium14Grey77,
      textAlign: TextAlign.center,
    );
  }

  loginTitle() {
    return Text(
      getTranslate(context, 'login.LOGIN'),
      style: semibold21Primary,
      textAlign: TextAlign.center,
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blackColor,
          content: Text(
            getTranslate(context, 'exit_app.exit_text'),
            style: semibold15White,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}
