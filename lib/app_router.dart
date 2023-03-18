import 'package:flutter/material.dart';
import 'package:task_helper/models/task.dart';
import 'package:task_helper/models/task_type_enum.dart';
import 'package:task_helper/presentation/screens/account_screen.dart';
import 'package:task_helper/presentation/screens/create_task_screen.dart';
import 'package:task_helper/presentation/screens/home_screen.dart';
import 'package:task_helper/presentation/screens/layout_screen.dart';
import 'package:task_helper/presentation/screens/pre_register_Screen.dart';
import 'package:task_helper/presentation/screens/task_details_screen.dart';

import 'constants/strings.dart';
//Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
//         for: CN=assem hassan, OU=assem, O=assem, L=cairo, ST=cairo, C="+2"
class AppRouter{
//  keytool -genkey -v -keystore C:\Users\Asim\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias taskio
  AppRouter();

  Route? generateRoute(RouteSettings settings){
    switch (settings.name){
      case home:
        if(currentAccKey != null){
          return MaterialPageRoute(
            builder: (_) =>  LayoutScreen(),
          );
        }else{
          return MaterialPageRoute(
            builder: (_) =>  PreRegisterScreen(),
          );
        }


      case accountScreen:
        return MaterialPageRoute(
          builder: (_) => AccountScreen(),
        );
      case createTask:
        final taskType = settings.arguments as TaskType;
        debugPrint(taskType.toString());
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(taskType: taskType,),
        );
      case taskScreen:
        final Task task = settings.arguments as Task;
        return MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(task: task,),
        );
      case preRegisterScreen:
        return MaterialPageRoute(
          builder: (_) => PreRegisterScreen(),
        );
      default:
    }
    return null;
  }
}