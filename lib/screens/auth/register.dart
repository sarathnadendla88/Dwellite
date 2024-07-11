import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/loader_view.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:dwellite/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController entryCodeController = TextEditingController();
  final TextEditingController blockNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
    } catch (e) {
      print('Error obtaining device ID: $e');
    }
  }

  Future<void> registerData() async {
    LoaderView().pleaseWaitDialog(context);
    Map<String, dynamic> jsonObject = {
      "name": usernameController.text,
      "email": emailController.text,
      "phone_code": "+91",
      "phone_number": phoneController.text,
      "flat_number": entryCodeController.text,
      "block_number": blockNumberController.text,
      "device_id": deviceId,
      "dob": dateController.text
    };

    Response<dynamic> res =
        await _apiService.registerData(jsonEncode(jsonObject));

    LoaderView().cancelDialog();
    if (res.statusCode == 200) {
      print(res);
      var data = res.data['data'];

      SharedPreferencesHelper()
          .saveData('useraccesstoken', data['access_token']);
      Navigator.popAndPushNamed(context, '/bottomBar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  registerText(),
                  heightSpace,
                  pleaseText(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  userNameField(),
                  heightSpace,
                  height5Space,
                  phoneField(),
                  heightSpace,
                  height5Space,
                  emailField(),
                  heightSpace,
                  height5Space,
                  entryCodeField(),
                  heightSpace,
                  height5Space,
                  blockNumberField(),
                  heightSpace,
                  height5Space,
                  dobField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  height5Space,
                  registerButton(),
                  heightSpace,
                  heightSpace,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  pleaseText() {
    return Text(
      getTranslate(context, 'register.please_text'),
      textAlign: TextAlign.center,
      style: medium14Grey77,
    );
  }

  registerText() {
    return Text(
      getTranslate(context, 'register.REGISTER'),
      style: semibold21Primary,
      textAlign: TextAlign.center,
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        if (usernameController.text.isEmpty) {
          Utils.showError(context, "Please enter name.");
        } else if (phoneController.text.isEmpty) {
          Utils.showError(context, "Please enter phone number.");
        } else if (emailController.text.isEmpty) {
          Utils.showError(context, "Please select date.");
        } else if (entryCodeController.text.isEmpty) {
          Utils.showError(context, "Please enter flat number.");
        } else if (blockNumberController.text.isEmpty) {
          Utils.showError(context, "Please enter block number.");
        } else if (dateController.text.isEmpty) {
          Utils.showError(context, "Please select DOB.");
        } else {
          registerData();
        }
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
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslate(context, 'register.register'),
          style: semibold18White,
        ),
      ),
    );
  }

  emailField() {
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
          ),
        ],
      ),
      child: TextField(
        controller: emailController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          prefixIcon: Container(
            width: 60.0,
            margin: languageValue == 4
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              border: languageValue == 4
                  ? const Border(
                      left: BorderSide(color: greyColor, width: 1.5),
                    )
                  : const Border(
                      right: BorderSide(color: greyColor, width: 1.5),
                    ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.mail_outline,
              size: 20,
            ),
          ),
          hintText: getTranslate(context, 'register.email_address'),
          hintStyle: medium16Grey,
        ),
      ),
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
          ),
        ],
      ),
      child: TextField(
        controller: phoneController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          prefixIcon: Container(
            width: 60.0,
            margin: languageValue == 4
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
                border: languageValue == 4
                    ? const Border(
                        left: BorderSide(color: greyColor, width: 1.5),
                      )
                    : const Border(
                        right: BorderSide(color: greyColor, width: 1.5),
                      )),
            alignment: Alignment.center,
            child: const Icon(
              Icons.phone_android,
              size: 20,
            ),
          ),
          hintText: getTranslate(context, 'register.mobile_number'),
          hintStyle: medium16Grey,
        ),
      ),
    );
  }

  userNameField() {
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
          ),
        ],
      ),
      child: TextField(
        controller: usernameController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          prefixIcon: Container(
            width: 60.0,
            margin: languageValue == 4
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              border: languageValue == 4
                  ? const Border(
                      left: BorderSide(color: greyColor, width: 1.5),
                    )
                  : const Border(
                      right: BorderSide(color: greyColor, width: 1.5),
                    ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.person,
              size: 20,
            ),
          ),
          hintText: getTranslate(context, 'register.user_name'),
          hintStyle: medium16Grey,
        ),
      ),
    );
  }

  entryCodeField() {
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
          ),
        ],
      ),
      child: TextField(
        controller: entryCodeController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          prefixIcon: Container(
            width: 60.0,
            margin: languageValue == 4
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              border: languageValue == 4
                  ? const Border(
                      left: BorderSide(color: greyColor, width: 1.5),
                    )
                  : const Border(
                      right: BorderSide(color: greyColor, width: 1.5),
                    ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.group,
              size: 20,
            ),
          ),
          hintText: getTranslate(context, 'Flat number'),
          hintStyle: medium16Grey,
        ),
      ),
    );
  }

  blockNumberField() {
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
          ),
        ],
      ),
      child: TextField(
        controller: blockNumberController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          prefixIcon: Container(
            width: 60.0,
            margin: languageValue == 4
                ? const EdgeInsets.only(left: 15.0)
                : const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              border: languageValue == 4
                  ? const Border(
                      left: BorderSide(color: greyColor, width: 1.5),
                    )
                  : const Border(
                      right: BorderSide(color: greyColor, width: 1.5),
                    ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.group,
              size: 20,
            ),
          ),
          hintText: getTranslate(context, 'Block number'),
          hintStyle: medium16Grey,
        ),
      ),
    );
  }

  dobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            onTap: () async {
              final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme:
                              const ColorScheme.light(primary: primaryColor)),
                      child: child!));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dateController.text = formattedDate;
                });
              }
            },
            readOnly: true,
            controller: dateController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, "DOB"),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
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
