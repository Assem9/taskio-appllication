import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/constants/strings.dart';

import '../../constants/my_colors.dart';
import '../../models/task_type_enum.dart';
import 'bottom_sheet_top.dart';
import 'default_button.dart';

class MyFloatingButton extends StatefulWidget {
  const MyFloatingButton({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<MyFloatingButton> createState() => _MyFloatingButtonState(scaffoldKey: scaffoldKey);
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  _MyFloatingButtonState({required this.scaffoldKey}) ;
  final GlobalKey<ScaffoldState> scaffoldKey;
  bool isShown =false ;
  IconData icon = Icons.add ;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        if(isShown){
          Navigator.pop(context);
          isShown = false ;
          setState(() {
            icon = Icons.add ;
          });
        }else{
          scaffoldKey.currentState!.showBottomSheet((context) => buildSheetWidget(context));
          isShown = true ;
          setState(() {
            icon = Icons.close ;
          });
        }

      },
      child:Icon(icon ,color: Colors.white,),);
  }

  Widget buildSheetWidget(context){
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 20),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppCubit.get(context).isDark ? MyColors.black2 :MyColors.white3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         // const BottomSheetTopWidget(),
          Text('Add?',style: Theme.of(context).textTheme.displaySmall,),
          Row(
            children: [
              buildAddPlanWidget(context),
              const Spacer(),
              buildAddTaskWidget(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAddPlanWidget(context){
    return InkWell(
      onTap:()=> Navigator.pushNamed(context, createTask,arguments: TaskType.isPLAN),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width / 3,
        child: Stack(
          children: [
            PhysicalModel(
              borderRadius:  BorderRadius.circular(5),
              color: AppCubit.get(context).isDark ? MyColors.black :MyColors.purple3,
              shadowColor: AppCubit.get(context).isDark? Colors.white : MyColors.black ,
              elevation: 6.0,
              shape: BoxShape.circle,
              child: Center(
                child: Text(
                  'Plan',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ),
            ),
            buildSubTask(top: 0, right: 20, title: 'task1', angle: pi/4),
            buildSubTask(top: 10, right: 15, title: 'task2', angle: pi/2),
            buildSubTask(top: 20, right: 0, title: 'task3', angle: -pi/4),
            buildSubTask(top: 40, right: 0, title: 'task4', angle:  pi/3),
          ],
        ),
      ),
    );
  }

  Widget buildSubTask({
    required double top ,
    required double right ,
    required String title ,
    required double angle ,
}){
    return Positioned(
        top: top,
        right: right,
        child: Transform.rotate(
          angle: angle,
          child: SizedBox(
            height: 30,
            width: 33,
            child: PhysicalModel(
              //borderRadius:  BorderRadius.circular(5),
              color: AppCubit.get(context).isDark ? MyColors.black : MyColors.purple1,
              shadowColor: AppCubit.get(context).isDark? Colors.black : MyColors.black ,
              elevation: 8.0,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontSize: 7),
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget buildAddTaskWidget(context){
    return InkWell(
      onTap: ()=> Navigator.pushNamed(context, createTask,arguments: TaskType.isTASK),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width / 3,
        child: PhysicalModel(
          borderRadius:  BorderRadius.circular(5),
          color: AppCubit.get(context).isDark ? MyColors.black :MyColors.purple2,
          shadowColor: AppCubit.get(context).isDark? Colors.white : MyColors.black ,
          elevation: 8.0,
          child: Center(
            child: Text(
              'Task',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }


}
