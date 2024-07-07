import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dwellite/core/api_service.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/screens/visitors/visitors_modal.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  late Future<List<VisitorItem>> visitorsData;
  final APIService _apiService = APIService.instance;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    visitorsData = getVisitors();
  }

  final visitorList = [
    {
      "image": "assets/visitor/visitor1.png",
    },
    {
      "image": "assets/visitor/visitor2.png",
    },
    {
      "image": "assets/visitor/visitor3.png",
    },
    {
      "image": "assets/visitor/visitor4.png",
    },
    {
      "image": "assets/visitor/visitor5.png",
    },
    {
      "image": "assets/visitor/visitor1.png",
    },
    {
      "image": "assets/visitor/visitor2.png",
    },
    {
      "image": "assets/visitor/visitor3.png",
    },
    {
      "image": "assets/visitor/visitor2.png",
    },
    {
      "image": "assets/visitor/visitor3.png",
    },
  ];

  Future<bool> deleteVisitorCall(String userId) async {
    Response<dynamic> res = await _apiService.deleteVisitor(userId);
    if (res.statusCode == 200) {
      print(res);
      var data = res.data['data'];
      if (data != null) {
        return true;
      } else {
        return false;
      }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res.data['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
      return false;
    }
  }

  Future<List<VisitorItem>> getVisitors() async {
    String res = await _apiService.getVisitorsList();

    Map<String, dynamic> data = jsonDecode(res);

    // Deserialize JSON data into Person object
    VisitorsModal modelData = VisitorsModal.fromJson(data);

    return modelData.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
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
        title: Text(
          getTranslate(context, 'visitors.visitors'),
          style: semibold18Black33,
        ),
      ),
      body: FutureBuilder(
          future: visitorsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            List<VisitorItem> data = snapshot.data ?? [];

            return visitorsListContent(data);
          }),
      bottomNavigationBar: preApproveVisitorsButton(context),
    );
  }

  emptyListContent() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: [
          Image.asset(
            "assets/home/visitor.png",
            height: 70,
          ),
          heightSpace,
          Text(
            getTranslate(context, 'visitors.no_visitors_yet'),
            style: semibold18Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  visitorsListContent(List<VisitorItem> dataItem) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, 0.0, fixPadding * 2.0, fixPadding),
      itemCount: dataItem.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: fixPadding),
          width: double.maxFinite,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(fixPadding),
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.1,
                      width: size.height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: AssetImage(
                            visitorList[index]['image'].toString(),
                          ),
                        ),
                      ),
                    ),
                    widthSpace,
                    width5Space,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataItem[index].detailsJson?.name ?? "",
                            style: medium16Black33,
                            overflow: TextOverflow.ellipsis,
                          ),
                          height5Space,
                          Text(
                            "${dataItem[index].entryDate}",
                            style: medium14Grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                          height5Space,
                          Text(
                            dataItem[index].visitStatus == 3001
                                ? "Pre approved"
                                : dataItem[index].visitStatus == 3002
                                    ? "IN"
                                    : "OUT",
                            style: medium15White.copyWith(
                              decoration: TextDecoration.underline,
                              color: dataItem[index].visitStatus == 3001 ||
                                      dataItem[index].visitStatus == 3003
                                  ? lightRedColor
                                  : (dataItem[index].visitStatus ==
                                          "Pre approved"
                                      ? orangeColor
                                      : green3EColor),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              DottedBorder(
                padding: EdgeInsets.zero,
                color: greyColor,
                dashPattern: const [2, 5],
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(fixPadding),
                child: Row(
                  children: [
                    optionWidget(Icons.call_outlined, "Call", () {
                      Navigator.pushNamed(context, '/call',
                          arguments: {"id": 1});
                    }),
                    optionWidget(
                      Icons.delete_outline,
                      getTranslate(context, 'visitors.delete'),
                      () {
                        setState(() {
                          deleteVisitorCall(
                              dataItem[index].visitorId.toString());
                          dataItem.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: blackColor,
                            duration: const Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              getTranslate(
                                  context, 'visitors.removed_from_visitors'),
                              style: semibold15White,
                            ),
                          ),
                        );
                      },
                    ),
                    optionWidget(
                      Icons.list_alt_outlined,
                      getTranslate(context, 'visitors.gatepass'),
                      () {
                        gatePassDialog(
                            context,
                            dataItem[index].detailsJson?.name ?? "",
                            dataItem[index].securityCode ?? "");
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  gatePassDialog(BuildContext context, String name, String securityCode) async {
    final size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          insetPadding: const EdgeInsets.all(fixPadding * 2.0),
          shadowColor: Colors.transparent,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              heightSpace,
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.25),
                      blurRadius: 6.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(fixPadding * 1.2),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getTranslate(context, 'visitors.gate_pass'),
                        style: semibold18WhiteF3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(fixPadding * 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: d5DEE3Color,
                              border: Border.all(color: whiteColor, width: 2.0),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withOpacity(0.25),
                                  blurRadius: 6.0,
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/visitor/guests.png",
                              height: 33,
                              width: 33,
                            ),
                          ),
                          width5Space,
                          widthSpace,
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: semibold16Black33,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                heightBox(3.0),
                                Text(
                                  "${getTranslate(context, 'visitors.guest_at')}  B-524",
                                  style: medium16Grey,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    DottedBorder(
                      padding: EdgeInsets.zero,
                      color: greyColor,
                      dashPattern: const [2.5, 4.5],
                      child: Container(
                        width: double.maxFinite,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(fixPadding * 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightSpace,
                          const Center(
                            child: Iconify(
                              Bi.qr_code_scan,
                              size: 110,
                              color: black33Color,
                            ),
                          ),
                          heightSpace,
                          heightSpace,
                          Text(
                            getTranslate(context, 'visitors.entry_code'),
                            style: semibold16Black33,
                          ),
                          heightSpace,
                          Container(
                            padding: const EdgeInsets.all(fixPadding * 1.4),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    color: shadowColor.withOpacity(0.25),
                                    blurRadius: 6.0)
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    securityCode,
                                    style: medium16Grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                widthSpace,
                                Icon(Icons.copy, size: 20.0, color: greyColor)
                              ],
                            ),
                          ),
                          height5Space,
                          Text(
                            getTranslate(context, 'visitors.show_qr_code'),
                            style: medium14Primary,
                          ),
                          heightSpace,
                          heightSpace,
                          height5Space,
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: fixPadding,
                                        vertical: fixPadding * 1.4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: shadowColor.withOpacity(0.25),
                                          blurRadius: 6.0,
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      getTranslate(context, 'visitors.share'),
                                      style: semibold18Black33,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              widthSpace,
                              widthSpace,
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: fixPadding,
                                        vertical: fixPadding * 1.4),
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
                                      getTranslate(
                                          context, 'visitors.download'),
                                      style: semibold18White,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  preApproveVisitorsButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/preApproveVisitors')
              .then((_) => setState(() {
                    visitorsData = getVisitors();
                  }));
          ;
        },
        child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.all(fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              vertical: fixPadding * 1.4, horizontal: fixPadding * 2.0),
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
            getTranslate(context, 'visitors.pre_approve_visitors'),
            style: semibold18White,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  optionWidget(IconData icon, String title, Function() onTap) {
    return Expanded(
        child: GestureDetector(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: greyColor,
              size: 20.0,
            ),
            width5Space,
            Expanded(
              child: Text(
                title,
                style: medium14Grey,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
