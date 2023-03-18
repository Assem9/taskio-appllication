import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/business_logic/task_cubit/task_cubit.dart';
import 'package:task_helper/business_logic/task_cubit/task_states.dart';
import 'package:task_helper/presentation/screens/pre_register_Screen.dart';
import 'package:task_helper/presentation/widgets/floatingActionButton.dart';
import 'package:task_helper/presentation/widgets/safeArea_top_bar.dart';
import '../../constants/strings.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit,TaskStates>(
      listener: (context ,state)async{
        if(state is TaskArchived){
          showToast(message: '${state.taskTitle} sent to archive');
          Navigator.pop(context);
        }
        if(state is TaskDeleted){
          showToast(message: '${state.taskTitle} Deleted');
          Navigator.pop(context);
        }
        if(state is TaskIsDone){
          showToast(message: '${state.task.title} Completed');
          Navigator.pop(context);
        }
        if(state is PlanSubTasksLoaded){
          TaskCubit.get(context).cancelAnimation();
          //Navigator.pushNamed(context, taskScreen,arguments: state.plan);
          await Future.delayed(
              const Duration(milliseconds: 700),
                  ()=> TaskCubit.get(context).setProgressWidthData(
                  plan: state.plan,
                  progressFullWidth: MediaQuery.of(context).size.width-28
              )
          );
        }

      },
      builder: (context, state){
        return Scaffold(
          key: scaffoldKey,
          // appBar: bar(context),
          body: SafeArea(
              minimum: const EdgeInsets.all(4),
              child:
              TaskCubit.get(context).account == null
                  ? const Center(child: CircularProgressIndicator(),)
                  : AppCubit.get(context).screens[AppCubit.get(context).botCurrentIndex]
            //AppCubit.get(context).screens[AppCubit.get(context).botCurrentIndex]

          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).botCurrentIndex,
              onTap: (index){
                if(index == 0 ){
                  AppCubit.get(context).getPickedDayTasks(context);
                }
                AppCubit.get(context).changeBotNavBar(index);

              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.today),label: 'Day'),
                BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.archive),label: 'Archive'),
              ]
          ),
          floatingActionButton: MyFloatingButton(scaffoldKey: scaffoldKey,),
        );
      }
    );
  }



}