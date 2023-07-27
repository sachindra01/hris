import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/view/attendance/attendance.dart';
import 'package:hris/src/view/common/leave_tabs.dart';
import 'package:hris/src/view/home/home.dart';
import 'package:hris/src/view/employee/employee_list.dart';
import 'package:hris/src/view/profile/profile.dart';

class BottomNavigation extends StatefulWidget {
  final int? index;
  const BottomNavigation({ Key? key, this.index }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with WidgetsBindingObserver{
  final AppController _con = Get.put(AppController());
  int _selectedIndex = 2;
  static final List<Widget> _pages = <Widget>[
    const LeaveTabs(),
    const Attendance(),
    const OnLeaveToday(),
    const EmployeeList(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    _selectedIndex =  widget.index ?? 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // drawer: const SidebarWidget(),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _pages.elementAt(_selectedIndex),
              ),
              Obx(() =>
                Visibility(
                  visible: _con.online.value == false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: const Text(
                        'Offline',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center
                      )
                    )
                  )
                )
              )
            ],
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: const Icon(Icons.directions_run),
              label: 'leaves'.tr
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.how_to_reg),
              label: 'attendance'.tr
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'home'.tr
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt),
              label: 'employee'.tr
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'profile'.tr
            )
          ]
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}