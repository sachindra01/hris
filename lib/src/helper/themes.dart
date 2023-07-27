import 'package:flutter/material.dart';

class MyTheme {

  // ignore: prefer_const_constructors
  static Color defaultColor = Color(0xFFdc3545);
  
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    primaryColor: defaultColor,
    scaffoldBackgroundColor: const Color(0xff3e3e3e),                    // defaultBackgroundColor
    iconTheme: const IconThemeData(color: Color(0xffF35555)),
    dividerColor: const Color(0xff959595),
    dividerTheme: const DividerThemeData(
      color: Color(0xff959595)
    ),
    splashColor: defaultColor,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.transparent,
      selectionColor: Colors.black
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: defaultColor
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: defaultColor
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
          color: Color(0xffffffff)
          )
        ),
        foregroundColor:  MaterialStateProperty.resolveWith((states) => const Color(0xffffffff)),
        backgroundColor: MaterialStateProperty.resolveWith((states) => defaultColor),
      )
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xffffffff)
      ),
      bodyMedium: TextStyle(
        color: Color(0xffffffff)
      ),
      bodySmall: TextStyle(
        color: Color(0xffffffff)
      ),
    ),
    cardColor: const Color(0xff464646),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey
      ),
      hintStyle: TextStyle(
        color: Colors.grey
      )
    )
  );

  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    primaryColor: defaultColor,
    scaffoldBackgroundColor: const Color(0xfffbfbfb),
    iconTheme: const IconThemeData(color: Color(0xffF35555)),
    dividerColor: Colors.black,
    splashColor: defaultColor,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionHandleColor: Colors.transparent,
      selectionColor: Colors.white
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: defaultColor
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: defaultColor
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
          color: Color(0xffffffff)
          )
        ),
        foregroundColor:  MaterialStateProperty.resolveWith((states) => const Color(0xffffffff)),
        backgroundColor: MaterialStateProperty.resolveWith((states) => defaultColor),
      )
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xff3F3F3F)
      ),
      bodyMedium: TextStyle(
        color: Color(0xff3F3F3F)
      ),
      bodySmall: TextStyle(
        color: Color(0xff3F3F3F)
      ),
    ),
    cardColor: const Color(0xffffffff),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      hintStyle: TextStyle(
        color: Colors.grey
      )
    )
  );
}