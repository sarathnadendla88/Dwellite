import 'dart:convert';

import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/loader_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceEntry extends StatefulWidget {
  const ServiceEntry({super.key});

  @override
  State<ServiceEntry> createState() => _ServiceEntryState();
}

class _ServiceEntryState extends State<ServiceEntry> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonNumberController = TextEditingController();
  TextEditingController insideTimeController = TextEditingController();
  TextEditingController serviceCompanyController = TextEditingController();

  final APIService _apiService = APIService.instance;
  VisitorType visitorType = VisitorType.maid;

  Future<void> addServiceEntryCall() async {
    Map<String, dynamic> jsonObject = {
      "visitor_type": visitorType,
      "entry_date": insideTimeController.text,
      "visitor_details": {
        'phone_number': phonNumberController.text,
        'name': nameController.text,
        'company_name': serviceCompanyController.text
      }
    };

    dynamic res =
        await _apiService.addVisitorEntryFromGuard(jsonEncode(jsonObject));

    print(res);

    var data = res.data['data'];
    print(data);
    print(res);

    Navigator.popAndPushNamed(context, '/bottomBar');

    if (data['access_token'] != null) {
      // to save token in local storage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['message']}'),
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
          getTranslate(context, 'service_entry.service_entry'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Image.asset(
            "assets/home/maid.png",
            height: size.height * 0.13,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          servicemanNameField(),
          heightSpace,
          heightSpace,
          phoneNumberField(),
          heightSpace,
          heightSpace,
          servicemanCompanyField(),
          heightSpace,
          heightSpace,
          insideTimeField(),
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
          LoaderView().pleaseWaitDialog(context);
          addServiceEntryCall();
          Navigator.pop(context);
          // Navigator.pushNamed(context, '/selectEntryAddress');
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
            getTranslate(context, 'service_entry.continue'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  insideTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'service_entry.inside_time'),
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
            controller: insideTimeController,
            onTap: () async {
              final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 3650),
                  ),
                  builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme:
                              const ColorScheme.light(primary: primaryColor)),
                      child: child!));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  insideTimeController.text = formattedDate;
                });
              }
            },
            readOnly: true,
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'service_entry.enter_inside_time'),
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

  servicemanCompanyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'service_entry.serviceman_company'),
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
            controller: serviceCompanyController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(
                  context, 'service_entry.enter_serviceman_company'),
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

  phoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'service_entry.phone_number'),
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
            controller: phonNumberController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'service_entry.enter_phone_number'),
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

  servicemanNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'service_entry.serviceman_name'),
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
                  getTranslate(context, 'service_entry.enter_serviceman_name'),
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
}
