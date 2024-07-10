import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:flutter/material.dart';

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
    visitorsActiveData = getAdminVisitors();
  }

  Future<void> getAdminVisitors() async {
    Response<dynamic> res = await _apiService.getAdminVisitors();
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

  Future<void> changeVisitorStatus(
      int userId, int visitorId, int visitorStatus) async {
    dynamic res = await _apiService.visitorStatusChangePost(
        userId, visitorId, visitorStatus);

    print("Sarath Res");
    print(res);

    print("Sarath Data");
    getAdminVisitors();
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
                getTranslate(context, 'admin.pending'),
                redColor,
                completedList[index]['id'],
                completedList[index]['id'],
                3002);
          },
        ));
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
                getTranslate(context, 'admin.pending'),
                redColor,
                pendingList[index]['id'],
                pendingList[index]['id'],
                3003);
          },
        ));
  }

  listContent(int index, image, text, name, boxText, boxColor, userId,
      visitorId, visitorStatus) {
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
            // changeVisitorStatus(
            //     int.parse(userId), int.parse(visitorId), visitorStatus);
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
              Container(
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
                      "${getTranslate(context, "Completed")}(${completedList.length})"),
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
