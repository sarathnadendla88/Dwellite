import 'package:dwellite/localization/localization_const.dart';
import 'package:dwellite/theme/theme.dart';
import 'package:dwellite/widget/column_builder.dart';
import 'package:flutter/material.dart';

class SelectEntryAddressScreen extends StatefulWidget {
  const SelectEntryAddressScreen({super.key});

  @override
  State<SelectEntryAddressScreen> createState() =>
      _SelectEntryAddressScreenState();
}

class _SelectEntryAddressScreenState extends State<SelectEntryAddressScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final blockAList = [
    "A-101",
    "A-102",
    "A-103",
    "A-104",
    "A-105",
    "A-106",
    "A-107",
    "A-108",
    "A-109",
    "A-110",
  ];
  final blockBList = [
    "B-101",
    "B-102",
    "B-103",
    "B-104",
    "B-105",
    "B-106",
    "B-107",
    "B-108",
    "B-109",
    "B-110",
  ];

  int selectedBlockA = 3;
  int selectedBlockB = 3;
  int selectedClubhouse = 3;
  int selectedCommonArea = 3;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          getTranslate(context, 'select_entry_address.guest_entry'),
          style: semibold18Black33,
        ),
      ),
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                blackAListContent(),
                blackBListContent(),
                clubhouseListContent(),
                commonAreaListContent(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: continueButton(),
    );
  }

  continueButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/confirmAndSendNotification');
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
              color: primaryColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Text(
          getTranslate(context, 'select_entry_address.continue'),
          style: semibold18White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  commonAreaListContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding * 2.0, fixPadding * 2.0, fixPadding),
      children: [
        title(),
        ColumnBuilder(
          itemBuilder: (context, index) {
            return listContent(index, selectedCommonArea, blockAList[index],
                () {
              setState(() {
                selectedCommonArea = index;
              });
            });
          },
          itemCount: blockAList.length,
        )
      ],
    );
  }

  clubhouseListContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding * 2.0, fixPadding * 2.0, fixPadding),
      children: [
        title(),
        ColumnBuilder(
          itemBuilder: (context, index) {
            return listContent(index, selectedClubhouse, blockAList[index], () {
              setState(() {
                selectedClubhouse = index;
              });
            });
          },
          itemCount: blockAList.length,
        )
      ],
    );
  }

  blackBListContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding * 2.0, fixPadding * 2.0, fixPadding),
      children: [
        title(),
        ColumnBuilder(
          itemBuilder: (context, index) {
            return listContent(index, selectedBlockB, blockBList[index], () {
              setState(() {
                selectedBlockB = index;
              });
            });
          },
          itemCount: blockBList.length,
        )
      ],
    );
  }

  blackAListContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          fixPadding * 2.0, fixPadding * 2.0, fixPadding * 2.0, fixPadding),
      children: [
        title(),
        ColumnBuilder(
          itemBuilder: (context, index) {
            return listContent(index, selectedBlockA, blockAList[index], () {
              setState(() {
                selectedBlockA = index;
              });
            });
          },
          itemCount: blockAList.length,
        )
      ],
    );
  }

  title() {
    return Text(
      getTranslate(context, 'select_entry_address.select_flat_num'),
      style: semibold16Grey,
    );
  }

  listContent(int index, selectedIndex, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: fixPadding),
        padding: const EdgeInsets.all(fixPadding * 1.3),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color:
                  selectedIndex == index ? primaryColor : Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: semibold16Black33,
        ),
      ),
    );
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
            isScrollable: true,
            controller: tabController,
            labelStyle: semibold16Black33.copyWith(fontFamily: "Inter"),
            labelColor: primaryColor,
            unselectedLabelColor: greyD9Color,
            unselectedLabelStyle: semibold16Grey.copyWith(fontFamily: "Inter"),
            tabs: [
              Tab(text: getTranslate(context, 'select_entry_address.block_a')),
              Tab(text: getTranslate(context, 'select_entry_address.block_B')),
              Tab(
                  text:
                      getTranslate(context, 'select_entry_address.clubhouse')),
              Tab(
                  text:
                      getTranslate(context, 'select_entry_address.common_area'))
            ],
          ),
        ),
      ],
    );
  }
}
