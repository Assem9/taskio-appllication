import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/presentation/widgets/safeArea_top_bar.dart';
import 'package:task_helper/presentation/widgets/tasks_grid_view.dart';

import '../../business_logic/task_cubit/task_cubit.dart';
import '../../constants/strings.dart';
import '../widgets/avatar.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12,),
        const SafeAreaTop(),
        const SizedBox(height: 10,),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white3,
            borderRadius: BorderRadius.circular(10)
          ),
            child: Text('Archived Tasks',style: Theme.of(context).textTheme.displaySmall,)),
        const SizedBox(height: 10,),
        Expanded(
            child: TasksGridView(tasks: TaskCubit.get(context).account!.archive)
        )
      ],
    );
  }

}
