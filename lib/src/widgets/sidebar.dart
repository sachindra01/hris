import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/view/home/home.dart';
import 'package:hris/src/view/employee/employee_list.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'HRIS',
                style: TextStyle(
                  fontSize: 74.0
                ),
              ),
            )
          ),
          ListTile(
            title: const Text('Employee List'),
            onTap: () {
              Get.back();
              Get.to(() => const EmployeeList());
            },
          ),
          ListTile(
            title: const Text('Employee On Leave Today'),
            onTap: () {
              Get.back();
              Get.to(() => const OnLeaveToday());
            },
          ),
        ],
      ),
    );
  }
}