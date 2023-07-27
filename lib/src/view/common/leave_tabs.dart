import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/leave_controller.dart';
import 'package:hris/src/helper/constant.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/view/home/approve_list.dart';
import 'package:hris/src/view/home/leave_list.dart';

class LeaveTabs extends StatefulWidget {
  const LeaveTabs({super.key});

  @override
  State<LeaveTabs> createState() => _LeaveTabsState();
}

class _LeaveTabsState extends State<LeaveTabs>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  final LeaveController _con = Get.put(LeaveController());

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 22.h,
          ),
          //Leave and Approver List tabbar
          TabBar(
            controller: tabController,
            padding: EdgeInsets.only(left: 16.w),
            isScrollable: true,
            labelColor: Get.isDarkMode ? white : greyShade3,
            labelStyle: notoSans(greyShade3, 17.0, 0.0),
            unselectedLabelColor: grey,
            unselectedLabelStyle: notoSans(grey, 17.0, 0.0),
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.2,
            tabs: [
              Obx(() => Tab(
                text: "${'leaveList'.tr} ( ${_con.leaveTaken.value} / $totalLeaveDaysAllowed)",
                height: 40,
              )),
              Tab(
                text: 'approveList'.tr,
                height: 40,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [LeaveList(), ApproveList()],
            ),
          ),
        ],
      ),
    );
  }
}
