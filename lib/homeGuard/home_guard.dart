import 'dart:convert';

import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/toast_helper.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:pinput/pinput.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  final TextEditingController securityCodeController = TextEditingController();

  final APIService _apiService = APIService.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<void> verifiySecurityCheck(String code) async {
    dynamic res = await _apiService.visitorEntryPost(code);
    print("Security Data Print");
    print(res);

    var data = res.data['data'];

    print(data);

    if (data != null) {
      Map<String, String> confirmData = convertDynamicToMap(res.data['data']);
      SharedPreferencesHelper()
          .saveData("confirmaData", jsonEncode(confirmData));

      Navigator.pushNamed(context, '/confirm');
    } else {
      ToastHelper().showLongToast(res.data['message']);
    }
  }

  final pinTheme = const PinTheme(
    width: 40,
    height: 45,
    textStyle: semibold18Primary,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: greyB4Color, width: 2.0),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: false,
        titleSpacing: 20.0,
        title: Row(
          children: [
            Container(
              height: 48.0,
              width: 48.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor,
                border: Border.all(color: whiteColor, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.2),
                    blurRadius: 6.0,
                  )
                ],
                image: const DecorationImage(
                  image: AssetImage("assets/home/profile-image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            widthSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sarath Nadendla",
                    style: semibold16Black33,
                    overflow: TextOverflow.ellipsis,
                  ),
                  heightBox(3.0),
                  const Text(
                    "Gate A | Dwellite society",
                    style: medium14Grey,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          visitorEntryBox(),
          addNewVisitor(size),
        ],
      ),
    );
  }

  addNewVisitor(Size size) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: f6f3Color,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Text(
              getTranslate(context, 'home.add_new_visitor'),
              style: semibold18Black33,
            ),
            heightSpace,
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: fixPadding * 2.0,
                crossAxisSpacing: fixPadding * 2.0,
                childAspectRatio: 1.3,
              ),
              children: [
                visitorType(size, "assets/home/guests.png",
                    getTranslate(context, 'home.guest_entry'), () {
                  Navigator.pushNamed(context, '/guestEntry');
                }),
                visitorType(size, "assets/home/cab.png",
                    getTranslate(context, 'home.cab_entry'), () {
                  Navigator.pushNamed(context, '/cabEntry');
                }),
                visitorType(size, "assets/home/food-delivery.png",
                    getTranslate(context, 'home.delivery_entry'), () {
                  Navigator.pushNamed(context, '/deliveryEntry');
                }),
                visitorType(size, "assets/home/maid.png",
                    getTranslate(context, 'home.service_entry'), () {
                  Navigator.pushNamed(context, '/serviceEntry');
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  visitorType(Size size, String image, String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: size.height * 0.065,
              width: size.height * 0.065,
            ),
            heightSpace,
            Text(
              title,
              style: semibold16Black33,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  visitorEntryBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 1.5,
          fixPadding * 2.0, fixPadding * 1.6),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 2.5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2F9),
        border: Border.all(color: const Color(0xFFD2E3EF)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            getTranslate(context, 'home.visitor_entry'),
            style: semibold18Primary,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          Text(
            getTranslate(context, 'home.enter_visitor_entry'),
            style: medium14Grey,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          heightSpace,
          height5Space,
          Pinput(
            controller: securityCodeController,
            length: 6,
            defaultPinTheme: pinTheme,
            focusedPinTheme: pinTheme.copyWith(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 2.0)),
              ),
            ),
            submittedPinTheme: pinTheme.copyWith(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 2.0)),
              ),
            ),
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    verifiySecurityCheck(securityCodeController.text);
                  },
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.2),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getTranslate(context, 'home.confirm'),
                      style: semibold18Primary,
                    ),
                  ),
                ),
              ),
              widthSpace,
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Iconify(
                  Carbon.qr_code,
                  color: whiteColor,
                  size: 30.0,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Function to convert dynamic data to Map<String, String>
  Map<String, String> convertDynamicToMap(dynamic data) {
    Map<String, String> resultMap = {};

    // Iterate over each key-value pair in the dynamic data
    data.forEach((key, value) {
      // Convert value to String (if possible)
      String stringValue = value.toString();

      // Add key-value pair to resultMap
      resultMap[key] = stringValue;
    });

    return resultMap;
  }
}
