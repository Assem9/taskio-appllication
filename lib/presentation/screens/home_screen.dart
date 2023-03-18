import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/presentation/widgets/safeArea_top_bar.dart';
import 'package:task_helper/presentation/widgets/tasks_grid_view.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../business_logic/task_cubit/task_states.dart';
import '../../models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<TaskCubit,TaskStates>(
      builder: (context, state){
        return Column(
          children: [
            const SizedBox(height: 12,),
            const SafeAreaTop(),
            const SizedBox(height: 12,),
            buildReportBoardWidget(context) ,
            const SizedBox(height: 10,),
            Text('ALL TASKS',style: Theme.of(context).textTheme.displaySmall,),
            const SizedBox(height: 10,),
            Expanded(
              child: TasksGridView(
                  tasks: TaskCubit.get(context).allItems
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildReportBoardWidget(context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 18),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          color: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple2,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.report_gmailerrorred,color: Colors.white,),
              const SizedBox(width: 6,),
              Text(
                'Report Board',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                  child: taskReportWidget(
                      context,
                      text: 'Plan',
                      items: TaskCubit.get(context).account!.plans
                  )
              ),
              const SizedBox(width: 10,),
              Expanded(
                  child: taskReportWidget(
                      context,
                      text: 'Task',
                      items: TaskCubit.get(context).account!.tasks
                  )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget taskReportWidget(context,{required String text, required List<Task> items}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '- ${items.length} Created $text',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
        Text(
          '- ${items.where((element) => element.done).length} Done',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
      ],
    );
  }

}
