import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/controller/employee_controller.dart';
import 'package:hris/src/helper/launch_url.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/widgets/cached_network_image.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final EmployeeController _con = Get.put(EmployeeController());
  final AppController _appCon = Get.put(AppController());

  var searchTxt = TextEditingController();

  @override
  void initState() {
    _con.getEmployeeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _con.getEmployeeList(true),
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18.h,
            ),
            SizedBox(
              child: searchBar(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "employeeList".tr,
                style: notoSans(Get.isDarkMode ? white : greyShade3, 17.0, 0.0),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              height: 2.h,
              width: Get.locale!.languageCode == "en" ? 110.w : 116.w,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 4.h,
            ),
            Obx(() => _con.isLoading.value == true
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.32,
                      ),
                      Center(
                        child: Obx(() => Visibility(
                          visible: _con.ptr.value == false,
                          child: const CircularProgressIndicator()
                        )),
                      ),
                    ],
                  )
                : Expanded(child: displayListType())
            ),
            Obx(() => 
              _appCon.online.value
                ? const SizedBox()
                : const SizedBox(height: 20.0)
            )
          ],
        ),
      )
          // : displayTile == true
          //   ? displayListType()
          //   : displayGridType()
          ),
    );
  }

  displayListType() {
    return ListView.builder(
      itemCount: _con.employeeList.length,
      itemBuilder: (ctx, index) {
        var emp = _con.employeeList[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 11.sp, vertical: 8.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: Get.isDarkMode
                      ? containerBorderDark
                      : containerBorderLight,
                  width: 1.2.sp),
            ),
            child: Row(
              children: [
                viewImage(emp.profileImageUrl),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text('${emp.fullName}  [${emp.roleName}]',
                        style: roboto(14, 0.0, FontWeight.bold)
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: InkWell(
                        onTap: () => routeUrl('mailto', emp.officialEmail),
                        child: Row(
                          children: [
                            const Icon(Icons.email, size: 20.0),
                            const SizedBox(width: 4.0),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.53,
                                child: Text('${emp.officialEmail}',
                                    style: roboto(12, 0),
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: () => routeUrl('tel', emp.phoneNo),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_android, size: 20.0),
                          Text(' ${emp.phoneNo}', style: roboto(12, 0)),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget viewImage(imgUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: DisplayNetworkImage(
        imageUrl: imgUrl,
        height: 60.0,
        width: 60.0
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.only(left: 10),
        height: 45,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.search_outlined,
              size: 20,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: searchTxt,
                textInputAction: TextInputAction.done,
                onChanged: (value) => _con.getFilteredEmployee(value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 4.0),
                  hintText: 'searchEmp'.tr,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }

}
