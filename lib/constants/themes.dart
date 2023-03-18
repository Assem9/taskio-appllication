import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_helper/constants/text_styles.dart';
import 'my_colors.dart';

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: MyColors.mainWhite,
    iconTheme: const IconThemeData(color: MyColors.purple2),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: MyColors.mainWhite),
    appBarTheme: const AppBarTheme(
      // backwardsCompatibility: false, //to control status bar (Default =true)
      systemOverlayStyle:SystemUiOverlayStyle(
          statusBarColor: MyColors.purple2,
          statusBarIconBrightness: Brightness.dark
      ) ,
      elevation: 0.0,
      backgroundColor: MyColors.purple2,
      iconTheme: IconThemeData(color: MyColors.mainWhite),
    ),
  textTheme: TextTheme(
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    bodyLarge: bodyLarge ,
    bodyMedium: bodyMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: GoogleFonts.aBeeZee(),
    bodySmall: GoogleFonts.aBeeZee()
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.purple2,
      elevation: 20.0,
      unselectedItemColor: MyColors.purple2.withOpacity(0.5),//Colors.grey[400]
      backgroundColor: Colors.white

  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MyColors.purple3
  )
);


ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: MyColors.black2),
    iconTheme: const IconThemeData(color: MyColors.lightColor),
  scaffoldBackgroundColor: MyColors.black2,
    appBarTheme: const AppBarTheme(
      // backwardsCompatibility: false, //to control status bar (Default =true)
      systemOverlayStyle:SystemUiOverlayStyle(
          statusBarColor: MyColors.darkColor,
          statusBarIconBrightness: Brightness.dark
      ) ,
      elevation: 0.0,
      backgroundColor: MyColors.darkColor,
      iconTheme: IconThemeData(color: MyColors.mainWhite),
    ),
  textTheme: TextTheme(
      displayMedium: displayMedium.copyWith(color: MyColors.mainWhite),
      displaySmall: displaySmall.copyWith(color: MyColors.mainWhite),
      bodyLarge: bodyLarge.copyWith(color: MyColors.mainWhite) ,
      bodyMedium: bodyMedium.copyWith(color: MyColors.mainWhite),
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: GoogleFonts.aBeeZee().copyWith(color: MyColors.mainWhite),
      bodySmall: GoogleFonts.aBeeZee().copyWith(color: MyColors.mainWhite)
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.lightColor,
      elevation: 20.0,
      unselectedItemColor: MyColors.lightColor.withOpacity(0.5),//Colors.grey[400]
      backgroundColor: MyColors.black2

  ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.lightColor
    )

);

//ThemeData setTheme(){}

