import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/constants/strings.dart';
import 'package:task_helper/models/task_type_enum.dart';
import 'package:task_helper/presentation/widgets/alert_dialog.dart';
import 'package:task_helper/presentation/widgets/appbar.dart';
import 'package:task_helper/presentation/widgets/default_button.dart';
import 'package:task_helper/presentation/widgets/task_item.dart';
import 'package:task_helper/presentation/widgets/textfield.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../business_logic/task_cubit/task_states.dart';
import '../../models/task.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({Key? key, required this.task}) : super(key: key);
  final Task task ;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final noteController = TextEditingController();
  final noteFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 12),
        child: Column(
          children: [
            buildTaskTextData(context),
            const SizedBox(height: 10,),
            buildTaskDatesDetailsWidget(context),
            const SizedBox(height: 10,),
            task.type == TaskType.isPLAN ?
            buildPlanExtraFeatures()  : Container(),
            const SizedBox(height: 25,),
            DefaultButton(
              height: 50,
              color: AppCubit.get(context).isDark ? null : MyColors.purple1,
              title: 'Open Notes Book',
              onTap: ()=> scaffoldKey.currentState!.showBottomSheet(
                      (context) => buildNotesWidgetBottomSheet(context)
              ),
            ),
            const SizedBox(height: 30,),
            buildButtonsRow(context),
            const SizedBox(height: 10,),
            buildLinksContainer(context),

          ],
        ),
      ),
    );
  }

  Widget buildPlanExtraFeatures(){
    return BlocConsumer<TaskCubit,TaskStates>(
      listener: (context ,state)async{
        if(state is TaskIsDone ){
          if(state.task.type == TaskType.isSUBTASK){
          //  AppCubit.get(context).cancelAnimation();
            await Future.delayed(
                const Duration(milliseconds: 500),
                    ()=> TaskCubit.get(context).setProgressWidthData(
                    plan: task,
                    progressFullWidth: MediaQuery.of(context).size.width-28
                )
            );
          }
        }
      },
        builder:(context, state){
          return Column(
            children: [
              buildProgressWidget(context),
              const SizedBox(height: 10,),
              buildSubTasksGridView(context)
            ],
          );
        }
        );
  }

  Widget buildTaskDatesDetailsWidget(context){
    return SizedBox(
      width: double.infinity,
      child: Row( 
        children: [
          Expanded(
            child: buildDateWidget(
                context,
                title: 'Start Date',
                value: AppCubit.get(context).setDateTimeFormat(task.startDate)
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: buildDateWidget(
                context,
                title: 'Deadline ',
                value: AppCubit.get(context).setDateTimeFormat(task.deadLine)
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateWidget(context,{required String title, required String value}){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppCubit.get(context).isDark? MyColors.darkColor :MyColors.white3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium,),
          const SizedBox(height: 5,),
          Text(value, style: Theme.of(context).textTheme.bodySmall,),
        ],
      ),
    );
  }

  Widget buildLinksContainer(context){
    return BlocConsumer<TaskCubit,TaskStates>(
      listener: (context ,state){
        if(state is NewLinkAdded){
          Navigator.pop(context);
        }
      },
      builder: (context ,state){
        return Container(
          padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
          decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: 2,
                    color: AppCubit.get(context).isDark? MyColors.lightColor :MyColors.purple3,
                ),
              top: BorderSide(
                width: 2,
                color: AppCubit.get(context).isDark? MyColors.lightColor :MyColors.purple3,
              ),
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.link,size: 30,),
                  Text(
                    ' Links',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppCubit.get(context).isDark?MyColors.lightColor : MyColors.purple4),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: ()=> showDialog(
                        context: context,
                        builder: (context)=> DefaultDialog(
                            title: 'Adding Link',
                            content: '',
                            contentWidget: buildLinkDataForm(),
                            onConfirm: ()=> TaskCubit.get(context).addNewLink(
                                task: task,
                                link: {
                                  'title':linkTitleController.text ,
                                  'url':linkUrlController.text ,
                                }
                            )
                        )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add,size: 25,),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10,),
              buildLinksListView()

            ],
          ),
        );
      },
    );
  }

  final linkTitleController = TextEditingController();
  final linkUrlController = TextEditingController();
  Widget buildLinkDataForm(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextField(
          controller: linkTitleController,
          label: 'Write title here',
          type: TextInputType.text,
          prefixIcon: Icons.drive_file_rename_outline ,
          border: const UnderlineInputBorder(),
        ),
        const SizedBox(height: 5,),
        DefaultTextField(
          controller: linkUrlController,
          label: 'Paste Url here',
          type: TextInputType.text,
          prefixIcon: Icons.drive_file_rename_outline ,
          border: const UnderlineInputBorder(),
        ),
      ],
    );
  }

  Widget buildLinkDetailsWidget(context,Map<String,String> link){
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppCubit.get(context).isDark? MyColors.darkColor :MyColors.white3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${link['title']}',style: Theme.of(context).textTheme.titleSmall,),
          TextButton(
              onPressed: ()async{
                var url = Uri.parse('${link['url']}');
                try{
                  await launchUrl(url,mode: LaunchMode.externalApplication)  ;
                }catch(e){
                  debugPrint('$e');
                }

              },
              child: Text(
                maxLines : 2,
                '${link['url']}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.underline,),
              )
          ),
        ],
      ),
    );
  }

  Widget buildLinksListView(){
    return SizedBox(
      //height: 300,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index)=> const SizedBox(height: 10,),
        itemCount: task.links.length,
        itemBuilder: (context, index)=> buildLinkDetailsWidget(context, task.links[index]),
      ),
    );
  }

  Widget buildTaskTextData(context){
    return Column(
      children: [
        Text(
          task.subTasks.isEmpty ?" " :"A Plan For",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          task.title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        //const SizedBox(height: 10,),
        Text(task.description?? ' ',style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }

  Widget buildButtonsRow(context){
    return Column(
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
                child: DefaultButton(
                    title: 'Archive',
                    color: task.type != TaskType.isSUBTASK
                        ? MyColors.purple4
                        : MyColors.purple4.withOpacity(0.5),
                    onTap: ()=> task.type != TaskType.isSUBTASK
                        ? showDialog(
                        context: context,
                        builder: (context)=> DefaultDialog(
                          title: 'Archive ',
                          content: 'are you sure you want to archive this',
                          onConfirm: ()=>TaskCubit.get(context).archiveTask(task)
                        )
                    )
                        : showToast(message: 'This task can\'t be archived *You can archive the whole plan*')
                )
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: DefaultButton(
                    color: MyColors.green,
                    title: 'Completed',
                    onTap: ()=> showDialog(
                        context: context,
                        builder: (context)=> DefaultDialog(
                          title: 'DONE? ',
                          content: 'press confirm if this task is done',
                          onConfirm: ()=> TaskCubit.get(context).completeTask(task),
                        )
                    )


                ),
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: DefaultButton(
                    title: 'Delete',
                    color: Colors.red,
                    onTap: ()=>showDialog(
                        context: context,
                        builder: (context)=> DefaultDialog(
                            title: 'Deleting ',
                            content: 'are you sure you want to delete this',
                            onConfirm: ()=>TaskCubit.get(context).deleteTask(task)
                        )
                    )
                )
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubTasksGridView(context){
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Plan\'s Tasks ',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppCubit.get(context).isDark? Colors.white : MyColors.purple2
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: (){
                TaskCubit.get(context).loadedPlan = task ;
                Navigator.pushNamed(context, createTask,arguments: TaskType.isSUBTASK);
              },
              child: const Icon(Icons.add,size: 25,),
            )
          ],
        ),
        const SizedBox(height: 5,),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio:1/1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index)=> TaskWidget(task: task.subTasks[index],),
          itemCount: task.subTasks.length,
        ),
        const SizedBox(height: 5,),
      ],
    );
  }

  Widget buildNotesWidgetBottomSheet(context){
    return BlocConsumer<TaskCubit,TaskStates>(
      listener: (context, state){
        if(state is NoteDeleted){
          Navigator.pop(context);
        }
      },
      builder: (context, state){
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 50,
            decoration: BoxDecoration(
                color: AppCubit.get(context).isDark? MyColors.black:MyColors.white3,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close,color: MyColors.black,)
                        )
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                task.notes.isEmpty
                    ? Text(
                  'You did not add any notes for this task yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
                    : Container(),
                const SizedBox(height: 6,),
                Form(
                  key: noteFormKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: DefaultTextField(
                          maxLines: 3,
                          controller: noteController,
                          label: 'write a note',
                          type: TextInputType.text,
                          prefixIcon: Icons.notes,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        flex: 2,
                        child: DefaultButton(
                            height: 65,
                            color: AppCubit.get(context).isDark ? null : MyColors.purple2,
                            title: 'ADD',
                            onTap:(){
                              if(noteFormKey.currentState!.validate()){
                                TaskCubit.get(context).addNewNote(task: task, note: noteController.text);
                              }
                            }
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index)=> const SizedBox(height: 5,),
                    itemCount: task.notes.length,
                    itemBuilder: (context, index)=> buildNoteWidget(context,task.notes[index]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildNoteWidget(context,String note){
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(TaskCubit.get(context).setTaskWidgetColor()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            note,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5,color: Colors.black),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: InkWell(
                onTap: ()=>  showDialog(
                    context: context,
                    builder: (context)=>DefaultDialog(
                      title: 'Note ',
                      content: 'are you sure you want to delete this note',
                      onConfirm: ()=> TaskCubit.get(context).deleteNote(task: task, note: note)
                    )
                ),
                child: const Icon(Icons.highlight_remove_outlined,))
        )
      ],
    );
  }

  Widget buildProgressWidget(context){
    return Column(
      children: [
        Text(
          'Plan\'s Progress ',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppCubit.get(context).isDark
                  ? Colors.white
                  : MyColors.purple2
          ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          height: 34,
          child: Stack(
            children: [
              Container(
                height: 34,
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.black,width: 2),
                  //borderRadius: BorderRadius.circular(10)
                ),
              ),
              Positioned(
                left: 2,
                top: 2,
                child: buildAnimatedPartListView(context),
              ),
              Center(
                  child: Text(
                    task.progress != 0 ?
                    '${task.progress.toString().substring(0,3)} %' : '0 %',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProgressAnimatedPart(context,int index){
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 2),
      width: TaskCubit.get(context).oneTaskWidth, //AppCubit.get(context).oneTaskWidth,
      height: 25,
      color: MyColors.green,
    );
  }

  Widget buildAnimatedPartListView(context){
    return SizedBox(
      height: 30,
      //width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: TaskCubit.get(context).nOfDoneTasks,
        itemBuilder: (context, index)=> buildProgressAnimatedPart(context, index),
      ),
    );
  }







///////////////////////// reminders ////////////////////
  Widget buildAlarmRemaindersContainer(context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      decoration: BoxDecoration(
          color: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white3,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Text('Task Remainders',style: Theme.of(context).textTheme.titleMedium,),
          const SizedBox(height: 10,),
          buildRemaindersListView(),
          const SizedBox(height: 5,),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: InkWell(
                child: Text(
                  'Advance remainders Settings',
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: MyColors.lightColor,decoration: TextDecoration.underline,),
                ),
                onTap: ()=> launchUrl(Uri.parse('https://pub.dev/packages/url_launcher/install') )
            ),
          )
        ],
      ),
    );
  }

  Widget buildRemaindersListView(){
    return SizedBox(
      height: 122,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index)=> const SizedBox(width: 10,),
        itemCount: 8,
        itemBuilder: (context, index)=> Column(
          children: [
            buildAlarmShapeWidget(
                context,
                color: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple2
            ),
            Switch(
              value: true,
              onChanged: (v){},
              activeColor: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple2,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAlarmShapeWidget(context,{required Color color}){
    return SizedBox(
      height: 70,
      width: 85,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '12/8 ',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
                Text(
                  '20:30',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            left: 60,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  height: 8,
                  width: 30,
                  color: color,
                ),
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 60,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Transform.rotate(
                angle: pi / -4,
                child: Container(
                  height: 8,
                  width: 30,
                  color: color,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                height: 4,
                width: 20,
                color: color,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Transform.rotate(
              angle: pi / -4,
              child: Container(
                height: 4,
                width: 20,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationSettingsWidget(context){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        decoration: BoxDecoration(
            color: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white3,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Text('Notification Settings', style: Theme.of(context).textTheme.titleMedium,),
            Row(
              children: [
                Text('Notify Start Date', style: Theme.of(context).textTheme.bodyMedium,),
                const Spacer(),
                Switch(value: false, onChanged: (value){},),
              ],
            ),
            Row(
              children: [
                Text('Notify Deadline', style: Theme.of(context).textTheme.bodyMedium,),
                const Spacer(),
                Switch(value: false, onChanged: (value){},),
              ],
            )
          ],
        )
    );
  }

}
