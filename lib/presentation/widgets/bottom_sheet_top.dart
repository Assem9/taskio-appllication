import 'package:flutter/material.dart';
import '../../business_logic/app_cubit/app_cubit.dart';
import '../../constants/my_colors.dart';

class BottomSheetTopWidget extends StatelessWidget {
  const BottomSheetTopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin:  const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          color: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white3,
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))
      ),
      child: const Icon(
        Icons.arrow_circle_down_rounded,
      ),
    );
  }
}
