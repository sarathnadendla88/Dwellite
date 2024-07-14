import 'dart:io';
import 'package:dwellite/homeGuard/home_guard.dart';
import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/screens/admin/admin.dart';
import 'package:dwellite/screens/inOut/in_out.dart';
import 'package:dwellite/screens/screens.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserType? userType;

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  DateTime? backPressTime;
  dynamic pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPrefData();
  }

  Future<void> sharedPrefData() async {
    var userTypeData =
        await SharedPreferencesHelper().readIntData(Constants.USER_TYPE_DATA);
    if (userTypeData == 1001) {
      userType = UserType.resident;
      var isAdmin =
          await SharedPreferencesHelper().readIntData(Constants.ISADMIN);
      if (isAdmin == 1) {
        userType = UserType.admin;
      }
    } else if (userTypeData == 1002) {
      userType = UserType.guard;
    } else {
      userType = UserType.resident;
    }

    setState(() {
      pages = userType == UserType.resident
          ? const [
              HomeScreen(),
              ServiceScreen(),
              ChatsScreen(),
              ProfileScreen(),
            ]
          : userType == UserType.admin
              ? const [
                  AdminScreen(),
                  HomeScreen(),
                  ServiceScreen(),
                  ChatsScreen(),
                  ProfileScreen(),
                ]
              : const [
                  GuardHomeScreen(),
                  InOutScreen(),
                  ChatsScreen(),
                  SettingsScreen(),
                ];
    });
  }

  final sendMessage = [
    {
      "image": "assets/home/system-administrator.png",
      "name": "Admin",
    },
    {
      "image": "assets/home/police.png",
      "name": "Security",
    },
  ];

  final securityAlert = [
    {
      "image": "assets/home/fire-extinguisher.png",
      "name": "Fire Alert",
    },
    {
      "image": "assets/home/elevator.png",
      "name": "Stuck in Lift",
    },
    {
      "image": "assets/home/dinosaur.png",
      "name": "Animal Threat",
    },
    {
      "image": "assets/home/terrorist.png",
      "name": "Visiter Threat",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: bottomBar(),
        floatingActionButton:
            (userType == UserType.resident || userType == UserType.admin)
                ? floatingButton()
                : const Text(''),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  bottomBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyB4Color,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: semibold14Primary,
      unselectedLabelStyle: semibold14GreyB4,
      currentIndex: selectedIndex,
      items: userType == UserType.resident
          ? [
              itemWidget(
                  Ri.home_4_line, getTranslate(context, 'bottom_bar.home')),
              itemWidget(FluentMdl2.repair,
                  getTranslate(context, 'bottom_bar.service')),
              itemWidget(Mdi.message_outline,
                  getTranslate(context, 'bottom_bar.chats')),
              itemWidget(Ep.user, getTranslate(context, 'bottom_bar.profile'))
            ]
          : userType == UserType.admin
              ? [
                  itemWidget(
                      Ep.user, getTranslate(context, 'bottom_bar.admin')),
                  itemWidget(
                      Ri.home_4_line, getTranslate(context, 'bottom_bar.home')),
                  itemWidget(FluentMdl2.repair,
                      getTranslate(context, 'bottom_bar.service')),
                  itemWidget(Mdi.message_outline,
                      getTranslate(context, 'bottom_bar.chats')),
                  itemWidget(
                      Ep.user, getTranslate(context, 'bottom_bar.profile'))
                ]
              : [
                  itemWidget(
                      Ri.home_4_line, getTranslate(context, 'bottom_bar.home')),
                  BottomNavigationBarItem(
                      icon: const Icon(
                        CupertinoIcons.arrow_up_arrow_down,
                        size: 22,
                      ),
                      label: getTranslate(context, 'bottom_bar.in_out')),
                  itemWidget(Mdi.message_outline,
                      getTranslate(context, 'bottom_bar.chats')),
                  BottomNavigationBarItem(
                      icon: const Icon(
                        CupertinoIcons.gear,
                      ),
                      label: getTranslate(context, 'bottom_bar.settings')),
                ],
    );
  }

  floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        securityAlertDialog();
      },
      elevation: 0,
      // backgroundColor: primaryColor,
      child: const Icon(
        CupertinoIcons.checkmark_shield,
        size: 30.0,
      ),
    );
  }

  securityAlertDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Dialog(
            alignment: Alignment.bottomCenter,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: const Color(0xFFE9F0F4),
            insetPadding: const EdgeInsets.fromLTRB(fixPadding * 4.0,
                fixPadding, fixPadding * 4.0, fixPadding * 10.0),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(fixPadding * 2.0),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  getTranslate(context, 'bottom_bar.send_message'),
                  style: semibold16Primary,
                ),
                heightSpace,
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: fixPadding * 2.0,
                    crossAxisSpacing: fixPadding * 2.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: sendMessage.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return gridListContent(
                        index,
                        sendMessage[index]['image'].toString(),
                        sendMessage[index]['name'].toString(), () {
                      Navigator.popAndPushNamed(context, '/message');
                    });
                  },
                ),
                heightSpace,
                heightSpace,
                Text(
                  getTranslate(context, 'bottom_bar.security_alert'),
                  style: semibold16Primary,
                ),
                heightSpace,
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: fixPadding * 2.0,
                    crossAxisSpacing: fixPadding * 2.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: securityAlert.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return gridListContent(
                        index,
                        securityAlert[index]['image'].toString(),
                        securityAlert[index]['name'].toString(),
                        () {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  gridListContent(int index, String image, String name, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.25),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              height: 40.0,
              width: 40.0,
            ),
            height5Space,
            Text(
              name,
              style: medium15Primary,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  itemWidget(String icon, String title) {
    return BottomNavigationBarItem(
      icon: Iconify(icon, color: greyColor),
      activeIcon: Iconify(icon, color: primaryColor),
      label: title,
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
