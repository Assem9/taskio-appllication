import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/task_cubit/task_states.dart';

import '../../business_logic/app_cubit/app_cubit.dart';
import '../../business_logic/task_cubit/task_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/strings.dart';
import 'avatar.dart';


class SafeAreaTop extends StatelessWidget {
  const SafeAreaTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit,TaskStates>(
      builder: (context, state){
        return Row(
          children: [
            InkWell(
              onTap:(){
                AppCubit.get(context).accountInitialAnimate(
                    firstPos: 0,
                    secPos: - MediaQuery.of(context).size.width
                );
                Navigator.pushNamed(context, accountScreen);
              },
              child: UserAvatar(avatarUrl: TaskCubit.get(context).account!.avatar),
            ),
            const SizedBox(width: 10,),
            Text(
              'Hi, ${TaskCubit.get(context).account!.name} ',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const Spacer(),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: ()=> AppCubit.get(context).changeTheme(null),
              icon: Icon(
                Icons.dark_mode,
                size: 40,
                color: AppCubit.get(context).isDark ? MyColors.mainWhite : MyColors.black,
              ),
            ),

          ],
        );
      },
    );
  }

}
