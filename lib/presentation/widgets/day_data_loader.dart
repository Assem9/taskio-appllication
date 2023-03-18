import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../business_logic/app_cubit/app_cubit.dart';
import '../../constants/my_colors.dart';

class DayDataLoader extends StatelessWidget {
  const DayDataLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 5,),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
              separatorBuilder: (context, index)=> const SizedBox(height: 6,),
              itemCount: 6,
              itemBuilder: (context, index)=> buildTaskByDateWidget(context,)
          ),
        ),
      ],
    );
  }
  Widget buildTaskByDateWidget(context){
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
          decoration: BoxDecoration(
              color: AppCubit.get(context).isDark ? MyColors.darkColor : MyColors.white3,
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: AppCubit.get(context).isDark ? MyColors.darkColor : MyColors.white3,
                borderRadius: BorderRadius.circular(20)
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //task.type == TaskType.isSUBTASK ?
                Container(
                  width: setRandomWidth(context,3,1),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AppCubit.get(context).isDark ? MyColors.black2 : MyColors.white2,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                const SizedBox(height: 6,),
                Container(
                  padding: const EdgeInsets.all(6),
                  width: setRandomWidth(context,5,2),
                  decoration: BoxDecoration(
                      color: AppCubit.get(context).isDark ? MyColors.black : MyColors.white2,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  double setRandomWidth(context,int max,int min){
    double screenWidth = MediaQuery.of(context).size.width ;
    var rand = Random().nextInt(max) + min;
    return screenWidth / rand ;
  }

}
