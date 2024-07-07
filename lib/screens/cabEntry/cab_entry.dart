import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/loader_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CabEntryScreen extends StatefulWidget {
  const CabEntryScreen({super.key});

  @override
  State<CabEntryScreen> createState() => _CabEntryScreenState();
}

class _CabEntryScreenState extends State<CabEntryScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cabNumberController = TextEditingController();
  TextEditingController pickUpController = TextEditingController();
  TextEditingController cabCompanyController = TextEditingController();

  final APIService _apiService = APIService.instance;
  VisitorType visitorType = VisitorType.cab;

  Future<void> addCabEntryCall() async {
    LoaderView().pleaseWaitDialog(context);
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Map<String, dynamic> jsonObject = {
      "visitor_type": visitorType,
      "entry_date": formattedDate,
      "visitor_details": {
        'vehile_number': cabNumberController.text,
        'name': nameController.text,
        'company_name': cabCompanyController.text
      }
    };

    Response<dynamic> res =
        await _apiService.addVisitorEntryFromGuard(jsonEncode(jsonObject));

    LoaderView().cancelDialog();
    if (res.statusCode == 200) {
      print(res);
      var data = res.data['data'];
      print(data);

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black33Color,
          ),
        ),
        title: Text(
          getTranslate(context, 'cab_entry.cab_entry'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Image.asset(
            "assets/home/cab.png",
            height: size.height * 0.13,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          cabDriverNameField(),
          heightSpace,
          heightSpace,
          cabNumberField(),
          heightSpace,
          heightSpace,
          cabCompanyField(),
          heightSpace,
          heightSpace,
          pickOrDropField(),
        ],
      ),
      bottomNavigationBar: continueButton(),
    );
  }

  continueButton() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          if (nameController.text.isEmpty) {
            errorText("Please enter name.");
          } else if (cabNumberController.text.isEmpty) {
            errorText("Please enter cab number.");
          } else if (pickUpController.text.isEmpty) {
            errorText("Please enter pickup location.");
          } else if (cabCompanyController.text.isEmpty) {
            errorText("Please enter cab company.");
          } else {
            addCabEntryCall();
            // Navigator.pushNamed(context, '/selectEntryAddress');
          }
        },
        child: Container(
          margin: const EdgeInsets.all(fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
          width: double.maxFinite,
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
          child: Text(
            getTranslate(context, 'cab_entry.continue'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  pickOrDropField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'cab_entry.pickup_droupup'),
          style: medium16Grey,
        ),
        heightSpace,
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
            controller: pickUpController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, 'cab_entry.enter_pickup_droupup'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  cabCompanyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'cab_entry.cab_company'),
          style: medium16Grey,
        ),
        heightSpace,
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
            controller: cabCompanyController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'cab_entry.enter_delivery_cab_company'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  cabNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'cab_entry.enter_last_digit_cab'),
          style: medium16Grey,
        ),
        heightSpace,
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
            controller: cabNumberController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, 'cab_entry.enter_last_digit_cab'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  cabDriverNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'cab_entry.cab_driver_name'),
          style: medium16Grey,
        ),
        heightSpace,
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
            controller: nameController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'cab_entry.enter_cab_driver_name'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  void errorText(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade300,
    ));
  }
}
