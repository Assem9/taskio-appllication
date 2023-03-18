import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../business_logic/app_cubit/app_cubit.dart';
import '../../constants/my_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.avatarUrl}) : super(key: key);
  final String avatarUrl ;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: MyColors.lightColor,
      shape: BoxShape.circle,
      elevation: 4,
      shadowColor: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.black,
      child: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage('assets/images/$avatarUrl'),
      ),
    );
  }
}
