import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/task_cubit/task_states.dart';
import 'package:task_helper/presentation/widgets/task_item.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../models/task.dart';

class TasksGridView extends StatelessWidget {
  const TasksGridView({Key? key, required this.tasks}) : super(key: key);
  final List<Task> tasks ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit,TaskStates>(
      builder: (context ,state){
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index)=> TaskWidget(task:tasks[index]),
          itemCount: tasks.length,
        );
      },
    );
  }

}
