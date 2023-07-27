import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DateTimeSelectedCallback = void Function(DateTime selectedDate, DateTime selectedTime);
typedef TimeSelectedCallback = void Function(TimeOfDay selectedTime, String hour, String minutes, String selectedAmPm);

class PickDate {
  static datePicker({
    required BuildContext context,
    required int? minYear,
    required int? maxYear,
    bool? hideYear,
    bool? hideMonth,
    bool? hideDay,
    bool? ymdFormat,
    bool? showMonthsInNumber,
    bool? displayFullMonthName,
    Color? pickerBackgroundColor,
    TextStyle? pickerTextStyle,
    double? pickerHeight,
    BorderRadius? pickerContainerBorderRadius,
    BorderRadius? buttonBorderRadius,
    double? buttonHeight,
    double? buttonWidth,
    Color? buttonColor,
    TextStyle? buttonTextStyle,
    String? buttonText,
    required DateTimeSelectedCallback onDateSelected,
    DateTime? initialDate,
    EdgeInsetsGeometry? pickerPadding,
    }) {
    final List<Map<String, dynamic>> months = [
      {"full_name": "January", "name": "Jan", "value": 1},
      {"full_name": "February", "name": "Feb", "value": 2},
      {"full_name": "March", "name": "Mar", "value": 3},
      {"full_name": "April", "name": "Apr", "value": 4},
      {"full_name": "May", "name": "May", "value": 5},
      {"full_name": "June", "name": "Jun", "value": 6},
      {"full_name": "July", "name": "Jul", "value": 7},
      {"full_name": "August", "name": "Aug", "value": 8},
      {"full_name": "September", "name": "Sep", "value": 9},
      {"full_name": "October", "name": "Oct", "value": 10},
      {"full_name": "November", "name": "Nov", "value": 11},
      {"full_name": "December", "name": "Dec", "value": 12},
    ];

    int daysInMonth(int year, int month) {
      return DateTime(year, month + 1, 0).day;
    }

    int selectedYear = initialDate?.year ?? DateTime.now().year; // Use the initialDate if provided, otherwise use the current year
    int selectedMonth = initialDate?.month ?? DateTime.now().month; // Use the initialDate if provided, otherwise use the current month
    int selectedDay = initialDate?.day ?? DateTime.now().day; // Use the initialDate if provided, otherwise use the current day
    int daysInSelectedMonth = daysInMonth(selectedYear, selectedMonth);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: pickerPadding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                color: pickerBackgroundColor ?? Theme.of(context).cardColor,
                borderRadius: pickerContainerBorderRadius ?? BorderRadius.circular(12.0),
              ),
              height: pickerHeight ?? MediaQuery.of(context).size.height * 0.36,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Year if YMD format is true
                        if (hideYear == null || hideYear == false && ymdFormat == true)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedYear - (minYear ?? DateTime.now().year),
                                  ),
                                  onSelectedItemChanged: (selectedItem) {
                                    setState(() {
                                      selectedYear = (minYear ?? DateTime.now().year) + selectedItem;
                                      daysInSelectedMonth = daysInMonth(selectedYear, selectedMonth);
                                      if (selectedDay > daysInSelectedMonth) {
                                        selectedDay = daysInSelectedMonth;
                                      }
                                    });
                                  },
                                  backgroundColor: pickerBackgroundColor ?? Theme.of(context).cardColor,
                                  itemExtent: 40,
                                  children: List<Widget>.generate(
                                    (maxYear ?? DateTime.now().year) - (minYear ?? DateTime.now().year) + 1,
                                    (index) => Center(
                                      child: Text(
                                        '${(minYear ?? DateTime.now().year) + index}',
                                        style: pickerTextStyle ?? const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Day
                        if (hideDay == null || hideDay == false && ymdFormat != true)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                                  onSelectedItemChanged: (selectedItem) {
                                    setState(() {
                                      selectedDay = selectedItem + 1;
                                    });
                                  },
                                  backgroundColor: pickerBackgroundColor ?? Theme.of(context).cardColor,
                                  itemExtent: 40,
                                  children: List<Widget>.generate(
                                    daysInSelectedMonth,
                                    (index) => Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: pickerTextStyle ?? const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Month
                        if (hideMonth == null || hideMonth == false)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedMonth - 1,
                                  ),
                                  onSelectedItemChanged: (selectedItem) {
                                    setState(() {
                                      selectedMonth = months[selectedItem]['value'];
                                      daysInSelectedMonth = daysInMonth(selectedYear, selectedMonth);
                                      if (selectedDay > daysInSelectedMonth) {
                                        selectedDay = daysInSelectedMonth;
                                      }
                                    });
                                  },
                                  backgroundColor: pickerBackgroundColor ?? Theme.of(context).cardColor,
                                  itemExtent: 40,
                                  children: List<Widget>.generate(
                                    12,
                                    (index) => Center(
                                      child: Text(
                                        showMonthsInNumber == true
                                            ? months[index]['value'].toString()
                                            : displayFullMonthName == true
                                                ? months[index]['full_name']
                                                : months[index]['name'],
                                        style: pickerTextStyle ?? const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Day if ymdIs true
                        if (hideDay == null || hideDay == false && ymdFormat == true)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                                  onSelectedItemChanged: (selectedItem) {
                                    setState(() {
                                      selectedDay = selectedItem + 1;
                                    });
                                  },
                                  backgroundColor: pickerBackgroundColor ?? Theme.of(context).cardColor,
                                  itemExtent: 40,
                                  children: List<Widget>.generate(
                                    daysInSelectedMonth,
                                    (index) => Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: pickerTextStyle ?? const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Year
                        if (hideYear == null || hideYear == false && ymdFormat != true)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedYear - (minYear ?? DateTime.now().year),
                                  ),
                                  onSelectedItemChanged: (selectedItem) {
                                    setState(() {
                                      selectedYear = (minYear ?? DateTime.now().year) + selectedItem;
                                      daysInSelectedMonth = daysInMonth(selectedYear, selectedMonth);
                                      if (selectedDay > daysInSelectedMonth) {
                                        selectedDay = daysInSelectedMonth;
                                      }
                                    });
                                  },
                                  backgroundColor: pickerBackgroundColor ?? Theme.of(context).cardColor,
                                  itemExtent: 40,
                                  children: List<Widget>.generate(
                                    (maxYear ?? DateTime.now().year) - (minYear ?? DateTime.now().year) + 1,
                                    (index) => Center(
                                      child: Text(
                                        '${(minYear ?? DateTime.now().year) + index}',
                                        style: pickerTextStyle ?? const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: buttonHeight ?? 45,
                    width: buttonWidth ?? 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: buttonColor ?? Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: buttonBorderRadius ?? BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                        onDateSelected(selectedDate, DateTime.now());
                        Navigator.pop(context);
                      },
                      child: Text(
                        buttonText ?? 'Select',
                        style: buttonTextStyle ?? const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Time Picker
  static void timePicker({
    required BuildContext context,
    required TimeSelectedCallback onTimeSelected,
    TimeOfDay? initialTime,
    Color? pickerBackgroundColor,
    TextStyle? pickerTextStyle,
    double? pickerHeight,
    BorderRadius? pickerContainerBorderRadius,
    BorderRadius? buttonBorderRadius,
    double? buttonHeight,
    double? buttonWidth,
    Color? buttonColor,
    TextStyle? buttonTextStyle,
    String? buttonText,
    EdgeInsetsGeometry? pickerPadding,
    }) {
    final selectedTime = initialTime ?? TimeOfDay.now();
    final amPmValues = ['AM', 'PM'];
    final hourValues = List<String>.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    final minuteValues = List<String>.generate(60, (index) => index.toString().padLeft(2, '0'));

    int selectedHour = selectedTime.hourOfPeriod;
    int selectedMinute = selectedTime.minute;
    String selectedAmPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: pickerHeight ?? MediaQuery.of(context).size.height * 0.36,
          padding: pickerPadding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color: pickerBackgroundColor ?? Theme.of(context).cardColor,
            borderRadius: pickerContainerBorderRadius ?? BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(initialItem: selectedHour - 1),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedHour = int.parse(hourValues[index]);
                        },
                        childCount: hourValues.length,
                        itemBuilder: (context, index) {
                          return Center(child: Text(hourValues[index], style: pickerTextStyle));
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(initialItem: selectedMinute),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedMinute = int.parse(minuteValues[index]);
                        },
                        childCount: minuteValues.length,
                        itemBuilder: (context, index) {
                          return Center(child: Text(minuteValues[index], style: pickerTextStyle));
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(initialItem: amPmValues.indexOf(selectedAmPm)),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedAmPm = amPmValues[index];
                        },
                        childCount: amPmValues.length,
                        itemBuilder: (context, index) {
                          return Center(child: Text(amPmValues[index], style: pickerTextStyle));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: buttonHeight ?? 45,
                width: buttonWidth ?? 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: buttonColor ?? Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: buttonBorderRadius ?? BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    final finalSelectedTime = TimeOfDay(
                      hour: selectedAmPm == 'PM' ? selectedHour + 12 : selectedHour,
                      minute: selectedMinute,
                    );
                    onTimeSelected(finalSelectedTime, selectedHour.toString().padLeft(2, "0"), selectedMinute.toString().padLeft(2, "0"), selectedAmPm);
                    Navigator.pop(context);
                  },
                  child: Text(
                    buttonText ?? 'Select',
                    style: buttonTextStyle ?? const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
