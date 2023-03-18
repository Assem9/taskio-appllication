import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_helper/business_logic/cacheHelper.dart';
import 'package:task_helper/business_logic/task_cubit/task_cubit.dart';
import 'package:task_helper/models/user.dart';
import 'package:task_helper/presentation/screens/archived_screen.dart';
import 'package:task_helper/presentation/screens/today_screen.dart';
import '../../constants/my_colors.dart';
import '../../models/task.dart';
import '../../models/task_type_enum.dart';
import '../../presentation/screens/home_screen.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool loading = false ;
  bool isDark = false ;
  void changeTheme(bool? fromShared){
    if(fromShared !=null) {
      isDark = fromShared ;
    }else{
      isDark = !isDark;
      try{
        CacheHelper.saveData(key: 'isDark', value: isDark) ;
        emit(ThemeChanged());
      }catch(e){
        debugPrint('$e');
      }

    }


  }

  int botCurrentIndex = 1 ;
  List<Widget> screens = [ const TodayScreen(),const HomeScreen(),const ArchivedScreen()];
  void changeBotNavBar(int index) {
    botCurrentIndex = index ;
    emit(ChangeBottomNavigationBar());
    //offer.products.add(laptop);
  }

  Color taskColor = MyColors.taskColors[0];
  int chosenColorInt = 1 ;
  void pickTaskColor(int pickedColor){
    taskColor = Color(pickedColor) ;
    chosenColorInt = pickedColor;
  //  colorPicked = true ;
    emit(ColorPicked());
  }

  String setDateTimeFormat(DateTime value){
    //var dateFormat = DateFormat('yyyy-MM-dd =>   hh:mm');
    var dateFormat2 = DateFormat.Hm() ;
    var dateFormat3 = DateFormat.MEd() ;
    String pickedDate = "${dateFormat3.format(value)}   ${dateFormat2.format(value)}";
    //emit(DateTimeFormatSet());
    return pickedDate;
  }

  double accountMainWidgetPosition = 0;// left
  double addAccountWidgetPosition = 0;//right
  void accountAnimate({required double firstPos,required double secPos,}){
    accountMainWidgetPosition = firstPos;
    addAccountWidgetPosition = secPos;
    emit(AnimatingAccountWidget());
  }

  void accountInitialAnimate({
    required double firstPos,
    required double secPos,
  }){
    accountMainWidgetPosition = firstPos;
    addAccountWidgetPosition = secPos;
    emit(AnimatingAccountWidget());
  }

  List<DateTime> dates= [];
  void setWeekDates(){
    dates= [];
    DateTime previousDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day -1);
    dates.add(previousDay);
    for(int dayCounter = 0 ;dayCounter <6 ; dayCounter++ ){
      DateTime day = DateTime(
          dates[dayCounter].year,
          dates[dayCounter].month,
          dates[dayCounter].day +1
      );
      dates.add(day);
    }
    emit(WeekDaysDatesInitialized());

  }

  DateTime pickedDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day) ;
  void pickDayDate(context,{required DateTime day}){
    pickedDay = day ;
    getPickedDayTasks(context);
    emit(DayPicked());
  }

  Color setColorToDayWidget({required DateTime day}){
    if(pickedDay == day ){
      if(isDark){
        return MyColors.lightColor ;
      }else{
        return MyColors.purple2;
      }
    }else{
      if(isDark){
        return MyColors.darkColor ;
      }else{
        return MyColors.purple2.withOpacity(0.5);
      }
    }
  }

  List<Task> pickedDayTasks = [];
  void getPickedDayTasks(context)async{
    loading = true ;
    emit(Loading());
    pickedDayTasks = [];
    Account account = TaskCubit.get(context).account! ;
    List<Task> all =  account.tasks + account.plans + account.archive ;
    for(Task item in all){
      var itemDate = DateTime(item.startDate.year,item.startDate.month,item.startDate.day);
      if(itemDate == pickedDay){
        pickedDayTasks.add(item);
      }
      if(item.type == TaskType.isPLAN){
         for(Task sub in item.subTasks){
           itemDate = DateTime(sub.startDate.year,sub.startDate.month,sub.startDate.day);
           if(itemDate == pickedDay){
             pickedDayTasks.add(sub);
           }
         }
      }
    }
    await Future.delayed(
        const Duration(milliseconds: 600),
            (){
              loading = false ;
              emit(PickedDayDataLoaded()) ;
        }
    );

    print(pickedDayTasks.length.toString());
  }


//////////////////////////////////////// Notification Code ////////////////
/*
  late BoxCollection collection ;
  void openCollection() async{
    BoxCollection.open(
      'AppDatabase', // Name of your database
      {'accounts',}, // Names of your boxes
      path: directoryPath,
    ).then((value) {
      collection = value ;
      getUserAccount('Acc-20230313054939'); //Acc-20230313230149
      debugPrint('Collection path:  $directoryPath');
    }).catchError((e){
      debugPrint('Opening collection error=> $e');
    });
  }*/


}