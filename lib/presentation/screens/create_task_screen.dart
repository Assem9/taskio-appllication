import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/business_logic/task_cubit/task_states.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/constants/strings.dart';
import 'package:task_helper/models/task_type_enum.dart';
import 'package:task_helper/presentation/widgets/bottom_sheet_top.dart';
import 'package:task_helper/presentation/widgets/default_button.dart';
import 'package:task_helper/presentation/widgets/textfield.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../models/task.dart';
import '../widgets/appbar.dart';

class CreateTaskScreen extends StatelessWidget {
  CreateTaskScreen({Key? key, required this.taskType }) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController deadLineController = TextEditingController();
  final TextEditingController subTaskTitleController = TextEditingController();
  final TextEditingController subTaskDescriptionController = TextEditingController();
  final TextEditingController subTaskStartDateController = TextEditingController();
  final TextEditingController subTaskDeadLineController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final subFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TaskType taskType ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        child: Column(
          children: [
            taskType == TaskType.isSUBTASK ?
            Text(
              'Adding New task to the plan',
              style: Theme.of(context).textTheme.bodyMedium ,
            ) :
            Text(
              'Fill Next Data ',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppCubit.get(context).isDark ? Colors.white  :MyColors.purple2),
            ),
            const SizedBox(height: 10,),
            buildMainDataForm(context),
          ],
        ),
      ),
    );
  }

  Widget buildMainDataForm(context){
    return BlocConsumer<TaskCubit,TaskStates>(
      listener: (context, state){
        if(state is TaskAdded || state is PlanAdded){
          TaskCubit.get(context).updateHomeAllItems() ;
        }
        if(state is AllItemsListSorted){
          // After adding new item call updateItemsList first then go back to home
          Navigator.pop(context);
        }

        if(state is  SubTaskAddedToList){
          Navigator.pop(context);
          subTaskTitleController.text = '';
          subTaskDescriptionController.text = '';
          subTaskStartDateController.text = '';
          subTaskDeadLineController.text = '';
        }
        if(state is SubTaskAddedToDatabase){
          Navigator.pushReplacementNamed(context, taskScreen,arguments: TaskCubit.get(context).loadedPlan);
        }
      },
      builder: (context, state){
        return Form(
            key: formKey,
            child: Column(
              children: [
                buildTaskDataFields(
                    context,
                    title: titleController,
                    startDate: startDateController,
                    description: descriptionController,
                    deadLine: deadLineController
                ),
                const SizedBox(height: 10,),
                taskType == TaskType.isPLAN ? buildAddTasksToPlanWidget(context): Container(),
                const SizedBox(height: 6,),
                TaskCubit.get(context).dataLoader
                    ? const Center(child: LinearProgressIndicator(color: MyColors.purple2,),)
                    : Container(),
                const SizedBox(height: 4,),
                DefaultButton(
                    height: 60,
                    title: 'CONFIRM',
                    color: AppCubit.get(context).isDark ? null : MyColors.purple2,
                    onTap: (){
                      if(formKey.currentState!.validate()){
                        switch(taskType){
                          case TaskType.isPLAN:
                            if(TaskCubit.get(context).subTasksList.length >= 2){
                              TaskCubit.get(context).addNewPlan(
                                  title: titleController.text,
                                  description: descriptionController.text
                              );
                            }else{
                              showToast(message: 'Must Add at least 2 sub Tasks for A Plan');
                            }
                            break ;
                          case TaskType.isSUBTASK :
                            TaskCubit.get(context).addNewTaskToPlan(
                              title: titleController.text,
                              description: descriptionController.text,
                            ) ;
                            break ;
                          case TaskType.isTASK :
                            TaskCubit.get(context).addTask(
                                title: titleController.text,
                                description: descriptionController.text
                            ) ;
                            break;
                        }

                      }
                    }
                )
              ],
            )
        );
      },
    );
  }

  Widget buildTaskDataFields(context,{
    required TextEditingController title,
    required TextEditingController startDate,
    required TextEditingController description,
    required TextEditingController deadLine,
  }){
    return Column(
      children: [
        DefaultTextField(
            controller: title,
            label: 'Tile',
            type: TextInputType.text,
            prefixIcon: Icons.title
        ),
        DefaultTextField(
          controller: startDate,
          label: 'Set Start Date',
          type: TextInputType.none,
          prefixIcon: Icons.date_range,
          onTap: ()=> DatePicker.showDateTimePicker(
              context,
              minTime: DateTime.now(),
              onConfirm: (value){
                startDate.text = AppCubit.get(context).setDateTimeFormat(value);
                TaskCubit.get(context).startDate = value ;
              }
          ),
        ),
        DefaultTextField(
            controller: description,
            label: 'Description *optional*',
            type: TextInputType.text,
            prefixIcon: Icons.description
        ),
        DefaultTextField(
          controller: deadLine,
          label: 'Set Deadline Date *optional*',
          type: TextInputType.none,
          prefixIcon: Icons.date_range,
          onTap: ()=> DatePicker.showDateTimePicker(
              context,
              minTime: TaskCubit.get(context).startDate ,
              onConfirm: (value){
                deadLine.text = AppCubit.get(context).setDateTimeFormat(value);
                TaskCubit.get(context).deadLine = value ;
              }
          ),
        ),
      ],
    );
  }

  Widget buildSubTaskDataForm(context){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: MediaQuery.of(context).size.height - 150,
        decoration: BoxDecoration(
            color: AppCubit.get(context).isDark? MyColors.black : MyColors.purple1,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
        ),
        child: Form(
            key: subFormKey,
            child: Column(
              children: [
                const BottomSheetTopWidget(),
                const SizedBox(height: 8,),
                Text(
                  'Adding Task',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8,),
                buildTaskDataFields(
                    context,
                    title: subTaskTitleController,
                    startDate: subTaskStartDateController,
                    description: subTaskDescriptionController,
                    deadLine: subTaskDeadLineController
                ),
                const SizedBox(height: 10,),
                DefaultButton(
                    height: 60,
                    title: 'ADD',
                    color: AppCubit.get(context).isDark ? null : MyColors.purple3,
                    onTap: (){
                      if(subFormKey.currentState!.validate()){
                        TaskCubit.get(context).addToSubTasksList(
                          title: subTaskTitleController.text,
                          description: subTaskDescriptionController.text,
                        );

                      }
                    }
                )
              ],
            )
        ),
      ),
    );
  }

  Widget buildSubTaskWidget(context,Task subTask){
    return Container(
      padding: const EdgeInsets.all(8),
      height: 30,
      width: 80,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          color: Color(subTask.color),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        subTask.title,
        style: Theme.of(context).textTheme.bodySmall ,
      ),
    );
  }

  Widget subTasksList(context){
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context,index)=> const SizedBox(width: 4,),
        itemCount: TaskCubit.get(context).subTasksList.length,
        itemBuilder: (context,index)=> buildSubTaskWidget(context,TaskCubit.get(context).subTasksList[index]
        ),
      ),
    );
  }

  Widget buildAddTasksToPlanWidget(context){
    return Row(
      children: [
        DefaultButton(
          color: AppCubit.get(context).isDark?null :MyColors.purple1,
          width: 105,
            title: '+ Add Task',
            onTap: ()=> scaffoldKey.currentState!
                .showBottomSheet((context) => buildSubTaskDataForm(context)
            ),
        ),
        const SizedBox(width: 10,),
        Expanded(child: subTasksList(context)),
      ],
    );
  }

  Widget pickTaskBackgroundColor(context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
      decoration: BoxDecoration(
          color: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white3,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Text(
            '${taskType == TaskType.isPLAN? 'Plan' : 'Task' } Color:',
            style: Theme.of(context).textTheme.bodySmall!
                .copyWith(color: AppCubit.get(context).isDark? Colors.white : MyColors.purple2),
          ),
          const SizedBox(width: 10,),
          Expanded(child: colorsList()),
        ],
      ),
    );
  }

  Widget colorsList(){
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        separatorBuilder: (context,index)=> const SizedBox(width: 4,),
        itemCount: MyColors.hiveColors.length,
        itemBuilder: (context,index)=> InkWell(
          onTap: ()=> AppCubit.get(context).pickTaskColor( MyColors.hiveColors[index] ),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Color(MyColors.hiveColors[index]),
            child: AppCubit.get(context).taskColor == Color(MyColors.hiveColors[index])
                ? const Icon(Icons.done, color: MyColors.darkColor,)
                : Container(),
          ),
        ),
      ),
    );
  }

}
