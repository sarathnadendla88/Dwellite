import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/screens/admin/adminregister.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final APIService _apiService = APIService.instance;
  late Future<void> visitorsActiveData;
  late List<Map<String, String>> completedList = [];
  late List<Map<String, String>> pendingList = [];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    visitorsActiveData = getAdminResidents();
  }

  Future<void> getAdminResidents() async {
    Response<dynamic> res = await _apiService.getAdminResidents();
    if (res.statusCode == 200) {
      print(res);
      setState(() {
        completedList = convertDynamicToListOfMaps(res.data['data']['all']);
        pendingList = convertDynamicToListOfMaps(res.data['data']['pending']);
      });

      print(pendingList);
      print("Data PENDING");
      print(completedList);
      print("Data Completed");

      print("Sarath Data");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> approveResidentStatus(int userId, int visitorStatus) async {
    Response<dynamic> res =
        await _apiService.approveResidentStatus(userId, visitorStatus);
    if (res.statusCode == 200) {
      print("Resident Res");
      print(res);

      print("Resident Data");
      getAdminResidents();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> deleteResident(int userId) async {
    Response<dynamic> res = await _apiService.deleteResident(userId);

    if (res.statusCode == 200) {
      print("Delete Res");
      print(res);

      print("Delete Data");
      getAdminResidents();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 20.0,
        automaticallyImplyLeading: false,
        title: Text(
          getTranslate(context, 'admin.admin'),
          style: semibold18Black33,
        ),
      ),
      body: Column(
        children: [
          height5Space,
          height5Space,
          addResidentFromAdmin(),
          height5Space,
          height5Space,
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                pendingListContent(),
                completedListContent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  completedListContent() {
    return SizedBox(
        height: 200, // Replace with your desired height
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding),
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            // String? value = completedList[index]['details_json'];
            // String jsonString = _convertToJsonStringQuotes(raw: value!);

            // final Map<dynamic, dynamic> result = json.decode(jsonString);
            return listContent(
                index,
                // insideList[index]['image'].toString(),
                "assets/home/guests.png",
                "${completedList[index]['block_name']} | ${completedList[index]['phone_number']} | ${completedList[index]['email']}",
                completedList[index]['name'],
                getTranslate(context, 'admin.delete'),
                redColor,
                completedList[index]['id'],
                1,
                "completed",
                completedList[index]);
          },
        ));
  }

  showResidentDetails(BuildContext context, Size size, Map<String, String> data,
      residentStatus, boxText, boxColor) {
    return showDialog(
      context: context,
      builder: (context) {
        bool sendgatePass = true;
        return StatefulBuilder(builder: (context, state) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(fixPadding * 2.0),
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: size.height * 0.05),
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
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(fixPadding * 2.0,
                        size.height * 0.07, fixPadding * 2.0, fixPadding * 2.0),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              getTranslate(context, 'admin.resident_details'),
                              style: semibold16Black33,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          heightSpace,
                          heightSpace,
                          Row(children: [
                            dialogTitle(getTranslate(context, 'profile.name')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(
                                getTranslate(context, data['name'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(
                                getTranslate(context, 'profile.phone_number')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(getTranslate(
                                context, data['phone_number'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(getTranslate(context, 'Address')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(getTranslate(
                                context, data['address_line1'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(getTranslate(context, 'Block Name')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(getTranslate(
                                context, data['block_name'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(getTranslate(context, 'DOB')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(
                                getTranslate(context, data['dob'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(getTranslate(context, 'Email')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(
                                getTranslate(context, data['email'] ?? "")),
                          ]),
                          height5Space,
                          heightSpace,
                          Row(children: [
                            dialogTitle(
                                getTranslate(context, 'Requested Date')),
                            width5Space,
                            width5Space,
                            width5Space,
                            dialogTitle(getTranslate(
                                context, data['requested_date'] ?? "")),
                          ]),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: fixPadding * 1.4,
                                  vertical: fixPadding * 1.3),
                            ),
                          ),
                          heightSpace,
                          heightSpace,
                          submitButton(context, size, boxText, boxColor, () {
                            if (residentStatus == "pending") {
                              approveResidentStatus(int.parse(data['id']!), 1);
                            } else if (residentStatus == "completed") {
                              deleteResident(int.parse(data['id']!));
                            }
                            Navigator.pop(context);
                          }),
                          heightSpace,
                          heightSpace,
                          submitButton(context, size, "Cancel", blueColor, () {
                            Navigator.pop(context);
                          }),
                          heightSpace,
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  boxDecoration() {
    return BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.25),
          blurRadius: 6.0,
        )
      ],
    );
  }

  submitButton(
      BuildContext context, Size size, boxText, boxColor, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: boxColor,
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
          getTranslate(context, boxText),
          style: semibold18White,
        ),
      ),
    );
  }

  dialogTitle(String title) {
    return Text(
      title,
      style: medium16Black33,
    );
  }

  pendingListContent() {
    return SizedBox(
        height: 200, // Replace with your desired height
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding),
          itemCount: pendingList.length,
          itemBuilder: (context, index) {
            // String? value = pendingList[index]['details_json'];
            // String jsonString = _convertToJsonStringQuotes(raw: value!);

            // final Map<dynamic, dynamic> result = json.decode(jsonString);
            return listContent(
                index,
                // insideList[index]['image'].toString(),
                "assets/home/guests.png",
                "${pendingList[index]['block_name']} | ${pendingList[index]['phone_number']} | ${pendingList[index]['email']}",
                pendingList[index]['name'],
                getTranslate(context, 'admin.approve'),
                greenColor,
                pendingList[index]['id'],
                1,
                "pending",
                pendingList[index]);
          },
        ));
  }

  listContent(int index, image, text, name, boxText, boxColor, userId, status,
      residentStatus, Map<String, String> data) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(fixPadding * 0.8),
      margin: const EdgeInsets.symmetric(vertical: fixPadding),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 6.0,
          )
        ],
      ),
      child: GestureDetector(
          onTap: () {
            showResidentDetails(
                context, size, data, residentStatus, boxText, boxColor);
          },
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                padding: const EdgeInsets.all(fixPadding * 0.7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              widthSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: semibold15Black33,
                      overflow: TextOverflow.ellipsis,
                    ),
                    heightBox(3.0),
                    Text(
                      text,
                      style: medium14Grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                    heightBox(3.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.call,
                          color: blueColor,
                          size: 15,
                        ),
                        Expanded(
                          child: Text(
                            text,
                            style: medium14Black33,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (residentStatus == "pending") {
                    approveResidentStatus(int.parse(userId), status);
                  } else if (residentStatus == "completed") {
                    deleteResident(int.parse(userId));
                  }
                },
                child: Container(
                  width: 60,
                  padding: const EdgeInsets.all(fixPadding * 0.7),
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    boxText,
                    style: medium14White,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  // "Once you add resident there is no need to approve.By default it is approved",
  addResidentFromAdmin() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, '/adminregister');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminRegisterScreen(),
            ),
          ).then((value) {
            visitorsActiveData = getAdminResidents();
          });
        },
        child: Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: fixPadding * 0.75),
          padding: const EdgeInsets.all(fixPadding),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/home/members.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              heightBox(fixPadding * 0.8),
              const Text(
                "Add Resident",
                style: semibold15Black33,
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                "Once you add resident there is no need to approve.By default it is approved",
                style: medium14Grey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ));
  }

  tabBar() {
    return Stack(
      children: [
        Container(
          height: 45,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: greyD9Color, width: 2.0),
            ),
          ),
        ),
        SizedBox(
          height: 45.0,
          width: double.maxFinite,
          child: TabBar(
            controller: tabController,
            labelStyle: semibold16Black33.copyWith(fontFamily: "Inter"),
            labelColor: primaryColor,
            unselectedLabelColor: greyColor,
            unselectedLabelStyle: semibold16Grey.copyWith(fontFamily: "Inter"),
            tabs: [
              Tab(
                  text:
                      "${getTranslate(context, "Pending")}(${pendingList.length})"),
              Tab(
                  text:
                      "${getTranslate(context, "All")}(${completedList.length})"),
            ],
          ),
        ),
      ],
    );
  }

  String _convertToJsonStringQuotes({required String raw}) {
    /// remove space
    String jsonString = raw.replaceAll(" ", "");

    /// add quotes to json string
    jsonString = jsonString.replaceAll('{', '{"');
    jsonString = jsonString.replaceAll(':', '": "');
    jsonString = jsonString.replaceAll(',', '", "');
    jsonString = jsonString.replaceAll('}', '"}');

    /// remove quotes on object json string
    jsonString = jsonString.replaceAll('"{"', '{"');
    jsonString = jsonString.replaceAll('"}"', '"}');

    /// remove quotes on array json string
    jsonString = jsonString.replaceAll('"[{', '[{');
    jsonString = jsonString.replaceAll('}]"', '}]');

    return jsonString;
  }

  List<Map<String, String>> convertDynamicToListOfMaps(dynamic data) {
    List<Map<String, String>> resultList = [];

    // Check if data is a List<dynamic>
    if (data is List<dynamic>) {
      // Iterate through each item in the list
      for (var item in data) {
        // Check if item is a Map<String, dynamic>
        if (item is Map<String, dynamic>) {
          // Create a new Map<String, String> for each item
          Map<String, String> resultMap = {};
          // Iterate through each key-value pair in the map
          item.forEach((key, value) {
            // Convert value to String and add to resultMap
            resultMap[key] = value.toString();
          });
          // Add resultMap to resultList
          resultList.add(resultMap);
        }
      }
    }

    return resultList;
  }
}
