import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_states.dart';

import '../../business_logic/app_cubit/app_cubit.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../business_logic/task_cubit/task_states.dart';
import '../../constants/my_colors.dart';

class AvatarsListView extends StatelessWidget {
  const AvatarsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit,TaskStates>(
      builder: (context, state){
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio:1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index)=> InkWell(
            onTap: ()=> TaskCubit.get(context).pickAvatar(
              url: TaskCubit.get(context).avatars[index], name: '',
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                PhysicalModel(
                  color: MyColors.lightColor,
                  shape: BoxShape.circle,
                  elevation: 6,
                  shadowColor: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.black,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundImage: AssetImage('assets/images/${TaskCubit.get(context).avatars[index]}'),
                  ),
                ),
                TaskCubit.get(context).avatar == TaskCubit.get(context).avatars[index]
                    ? const Icon(Icons.done, color: MyColors.lightColor,size: 50,)
                    : Container(),
              ],
            ),
          ),
          itemCount: TaskCubit.get(context).avatars.length,
        );
      },

    );
  }
}
