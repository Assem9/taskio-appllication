import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'my_colors.dart';

const String preRegisterScreen = '/preRegisterScreen';
const String home = '/' ;
const String accountScreen ='/account';
const String createTask = '/create_Task_Screen' ;
const String taskScreen = '/Task_Details_Screen' ;
String directoryPath= '';
String? currentAccKey ;
List<String>? allKeys ;
bool? isDark ;



void showToast({required String message,})async
=> await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: MyColors.purple4,
      textColor: Colors.white,
      fontSize: 14.0,
    );

