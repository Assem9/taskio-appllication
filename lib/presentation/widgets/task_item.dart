import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/models/task_type_enum.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../models/task.dart';
import 'default_button.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({Key? key, required this.task}) : super(key: key);
  final Task task ;

  Map<String,dynamic> getTaskState(){
     if(task.done){
       return {
         'msg': 'Done',
         'color': Colors.green,
       } ;
     }
     else{
       var format = DateFormat.EEEE() ;
       return {
         'msg': 'On ${format.format(task.startDate)}',
         'color': MyColors.purple1,
       } ;
     }
  }

  @override
  Widget build(BuildContext context) {
    return task.type != TaskType.isSUBTASK
        ? Banner(
      location: BannerLocation.topStart,
      message: getTaskState()['msg'],
      color: getTaskState()['color'],
      //textStyle: , subTask
      child: buildTaskData(context),
    )
        :  Stack(
          children: [
            buildTaskData(context),
            smallBanner(
                context,
                msg: getTaskState()['msg'],
                color: getTaskState()['color']
            )
          ],
        );
  }

  Widget buildTaskData(context){
    return InkWell(
      onTap: () {
        if(task.type == TaskType.isPLAN){
          TaskCubit.get(context).getPlanData(task);
          Navigator.pushNamed(context, taskScreen,arguments: task);
        }else{
          Navigator.pushNamed(context, taskScreen,arguments: task);
        }
      }  ,
      onLongPress: ()=> showDialog(
          context: context,
          builder: (context)=> onLongPressDialog(context)
      ),
      child: PhysicalModel(
        borderRadius:  BorderRadius.circular(5),
        color: Color(task.color),
        shadowColor: AppCubit.get(context).isDark? Colors.white : MyColors.black ,
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              task.title,
              style: task.type != TaskType.isSUBTASK
                  ? Theme.of(context).textTheme.titleMedium
                  :Theme.of(context).textTheme.bodySmall ,
            ),
          ),
        ),
      ),
    );
  }

  Widget onLongPressDialog(context){
    return AlertDialog(
      icon: Container(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
            padding: const EdgeInsets.all(0),
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.close, size: 30,)
          )
      ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: AppCubit.get(context).isDark? MyColors.black2 : MyColors.white3,
        elevation: 10,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              DefaultButton(
                  color: MyColors.green,
                  title: 'COMPLETED !',
                  onTap: ()async{
                    TaskCubit.get(context).completeTask(task);
                    if(task.type == TaskType.isSUBTASK){

                    }

                  }

              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                      child: DefaultButton(
                          title: 'ARCHIVE',
                          color: task.type != TaskType.isSUBTASK
                              ? MyColors.purple4
                              : MyColors.purple4.withOpacity(0.5),
                          onTap: ()=> task.type != TaskType.isSUBTASK
                              ? TaskCubit.get(context).archiveTask(task)
                              : showToast(message: 'This task can\'t be archived *You can archive the whole plan*')
                      )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child:  DefaultButton(
                        title: 'DELETE',
                        color: Colors.red,
                        onTap: (){
                          TaskCubit.get(context).deleteTask(task);
                        }),
                  ),
                ],
              ),

            ],
          )
        ]
    );
  }

  Widget smallBanner(
      context,{
    required String msg,
    required Color color
  }){
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),)
      ),
      child: Text(
        msg,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w300,
          color: Colors.white
        ),
      ),
    );
  }

}
