import 'package:flutter/material.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/presentation/widgets/default_button.dart';
import '../../constants/my_colors.dart';

class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.contentWidget
  }) : super(key: key);

  final String title;
  final String content;
  final Function onConfirm ;
  final Widget? contentWidget ;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: contentWidget ??
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        backgroundColor: AppCubit.get(context).isDark? MyColors.black2 : MyColors.white3,
        elevation: 10,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                  child: DefaultButton(
                    color: AppCubit.get(context).isDark ? MyColors.darkColor : MyColors.purple1.withOpacity(0.6),
                    title: 'CANCEL',
                    onTap: ()=> Navigator.pop(context),
                  ),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: DefaultButton(
                    color: MyColors.green,
                    title: 'CONFIRM',
                    onTap: (){onConfirm();}
                ),
              ),
            ],
          )
        ]
    );
  }

}
