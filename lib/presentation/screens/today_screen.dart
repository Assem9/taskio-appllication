import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/constants/strings.dart';
import '../../models/task.dart';
import '../widgets/day_data_loader.dart';

class TasksByDayDateScreen extends StatelessWidget {
  const TasksByDayDateScreen({Key? key}) : super(key: key);
//Acc-20230314024926
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 25,),
          buildCalenderWidget(context),
          const SizedBox(height: 25,),
          buildWeekDaysListView(context ,dates: AppCubit.get(context).dates),
          const SizedBox(height: 25,),

          Expanded(
              child: AppCubit.get(context).loading
                  ? const DayDataLoader()
                  : AppCubit.get(context).pickedDayTasks.isNotEmpty
                  ? buildListOfPickedDayTasks(context)
                  : Text(
                'No Tasks Today',
                style: Theme.of(context).textTheme.bodyMedium,
              )
          ),



        ],
      ),
    );
  }

  Widget buildCalenderWidget(context){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.MMMEd().format(AppCubit.get(context).pickedDay),
              style: Theme.of(context).textTheme.displayMedium,

            ),
            Text(
              '${AppCubit.get(context).pickedDayTasks.length} Tasks Today',
              style: Theme.of(context).textTheme.bodyMedium,

            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: ()=> showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
          ).then((value) => AppCubit.get(context).pickDayDate(context,day: value!)
          ),
          child: PhysicalModel(
            shape: BoxShape.circle,
            elevation: 6,
            shadowColor: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.black,
            color: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: MediaQuery.of(context).size.width / 18,
              ),
            ),),
        ),
      ],
    );
  }

  Widget buildWeekDaysListView(context,{required List<DateTime> dates}){
    return SizedBox(
    height: MediaQuery.of(context).size.height / 7,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index)=> const SizedBox(width: 11,),
        itemCount: dates.length,
        itemBuilder: (context, index)=> buildGetDayWidget(context, dates[index]),
      ),
    );
  }

  Widget buildGetDayWidget(context,DateTime date){
    return InkWell(
      onTap: ()=> AppCubit.get(context).pickDayDate(context,day: date),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 7,
        width: MediaQuery.of(context).size.width / 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: PhysicalModel(
            borderRadius: BorderRadius.circular(20),
            elevation: 4,
            shadowColor: AppCubit.get(context).isDark ? MyColors.white2 : MyColors.black,
            color: AppCubit.get(context).setColorToDayWidget(day: date),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
              child: Column(
                children: [
                  Text(
                    DateFormat.E().format(date)  ,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  const Spacer(),
                  Text(
                    date.day.toString(),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskByDateWidget(context,{required Task task}){
    return Row(
      children: [
        Text(
          DateFormat.jm().format(task.startDate) ,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: InkWell(
            onTap: ()=> Navigator.pushNamed(context, taskScreen,arguments: task),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppCubit.get(context).isDark ?MyColors.darkColor : MyColors.white3,
                  borderRadius: BorderRadius.circular(20)
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //task.type == TaskType.isSUBTASK ?
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6,),
                  Text(
                    '${
                        DateFormat.jm().format(task.startDate)}'
                        ' - ${'${DateFormat.jm().format(task.deadLine)} '
                        '${DateFormat.Md().format(task.deadLine)}'
                    }',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildListOfPickedDayTasks(context){
     return ListView.separated(
       separatorBuilder: (context, index)=> const SizedBox(height: 6,),
       itemCount: AppCubit.get(context).pickedDayTasks.length,
       itemBuilder: (context, index)=> buildTaskByDateWidget(
           context,
           task: AppCubit.get(context).pickedDayTasks[index]
       )
     );
  }
}
