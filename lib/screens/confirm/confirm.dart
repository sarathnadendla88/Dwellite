import 'dart:convert';

import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/toast_helper.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late Map<String, dynamic> confirmData = {};
  final APIService _apiService = APIService.instance;
  late String data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataParse();
  }

  Future<void> changeVisitorStatus(
      int userId, int visitorId, int visitorStatus) async {
    dynamic res = await _apiService.visitorStatusChangePost(
        userId, visitorId, visitorStatus);

    print("Sarath Res");
    print(res);
    ToastHelper().showLongToast("In Successfully.");
    Navigator.pop(context);

    print("Sarath Data");
  }

  Future<void> dataParse() async {
    data = await SharedPreferencesHelper().readData('confirmaData');
    setState(() {
      confirmData = jsonDecode(data);
    });

    print(confirmData);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(context, size);
  }

  Scaffold FutureBuilder(BuildContext context, Size size) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black33Color,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          visitorImage(size),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: [
              detailBox(getTranslate(context, 'confirm.guest'),
                  confirmData['name'] ?? ""),
              widthSpace,
              widthSpace,
              detailBox(getTranslate(context, 'confirm.visiting'),
                  confirmData['block_name'] ?? ""),
              widthSpace,
              widthSpace,
              detailBox(getTranslate(context, 'confirm.gatepass'),
                  confirmData['security_code'] ?? ""),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          confirmAndSendinButton(context)
        ],
      ),
    );
  }

  visitorImage(Size size) {
    return Center(
      child: Container(
        height: size.width * 0.28,
        width: size.width * 0.28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
            image: AssetImage("assets/home/profile-image.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  confirmAndSendinButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeVisitorStatus(int.parse(confirmData['user_id']),
            int.parse(confirmData['visitor_id']), 3002);
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(fixPadding * 1.4),
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
          getTranslate(context, 'confirm.confirm_send_in'),
          style: semibold18White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  detailBox(String title, String detail) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 2.0, horizontal: fixPadding),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: medium16Grey,
              overflow: TextOverflow.ellipsis,
            ),
            heightSpace,
            Text(
              detail,
              style: semibold16Black33,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
