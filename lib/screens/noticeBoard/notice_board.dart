import 'package:dotted_border/dotted_border.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:flutter/material.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  final noticeList = [
    {
      "title": "Announcement",
      "detail":
          "Increasing maintenance to \$20 from  next month due to security increments",
      "timeAndDate": "19 AUG 05 : 300 PM",
      "isNew": true,
      "postBy": "Admin"
    },
    {
      "title": "New Year celebration",
      "detail":
          "New year gathering in Dwellite society's hall on 3rd november ",
      "timeAndDate": "20 AUG 05 : 30 PM",
      "isNew": true,
      "postBy": "Admin"
    },
    {
      "title": "Christmas party",
      "detail":
          "It is hereby notified that Christmas will be celebrated on 23rd December, 2018 at our Society auditorium. ",
      "timeAndDate": "22 Dec 08 : 30 PM",
      "isNew": false,
      "postBy": "Admin"
    },
    {
      "title": "New Year celebration",
      "detail": "New year gathering in Dwllite society's hall on 3rd november",
      "timeAndDate": "20 AUG 05 : 30 PM",
      "isNew": false,
      "postBy": "Admin"
    }
  ];

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
          getTranslate(context, 'notice_board.notice_board'),
          style: semibold18Black33,
        ),
      ),
      body: noticeboardListContent(),
    );
  }

  noticeboardListContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: fixPadding),
      itemCount: noticeList.length,
      itemBuilder: (context, index) {
        return Container(
          clipBehavior: Clip.hardEdge,
          width: double.maxFinite,
          padding: languageValue == 4
              ? const EdgeInsets.only(right: fixPadding)
              : const EdgeInsets.only(left: fixPadding),
          margin: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: fixPadding * 1.4,
                          right: fixPadding,
                          top: fixPadding,
                        ),
                        child: Text(
                          noticeList[index]['title'].toString(),
                          style: semibold16Black33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    noticeList[index]['isNew'] == true
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: fixPadding * 1.3,
                                vertical: fixPadding / 2),
                            color: primaryColor,
                            alignment: Alignment.center,
                            child: Text(
                              getTranslate(context, 'notice_board.new'),
                              style: semibold12White,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                height5Space,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
                  child: Text(
                    noticeList[index]['detail'].toString(),
                    style: medium14Grey,
                  ),
                ),
                heightSpace,
                DottedBorder(
                  padding: EdgeInsets.zero,
                  color: greyColor,
                  dashPattern: const [2.5, 4.5],
                  child: Container(
                    width: double.maxFinite,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 1.5,
                    vertical: fixPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${getTranslate(context, 'notice_board.post_by')} :${noticeList[index]['postBy']}",
                          style: medium14Black33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          noticeList[index]['timeAndDate'].toString(),
                          style: medium14Grey,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
