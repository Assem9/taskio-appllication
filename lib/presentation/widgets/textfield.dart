import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import '../../constants/my_colors.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller ;
  final String label ;
  final TextInputType type ;
  final IconData prefixIcon ;
  final Function? onTap ;
  final int? maxLines ;
  final int? maxLength ;
  final InputBorder? border ;

  const DefaultTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.type,
    required this.prefixIcon,
    this.onTap,
    this.maxLines,
    this.border,
    this.maxLength
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration:  BoxDecoration(
          color: AppCubit.get(context).isDark ? MyColors.darkColor : MyColors.white2,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        style: Theme.of(context).textTheme.bodySmall,
        controller: controller ,
        onTap: (){
          if(onTap != null){
            onTap!();
          }},
        validator: (value){
          if(value!.isEmpty) {
            return 'please enter $label ';
          }
          return null;
        },
      //  cursorColor: Colors.red,
        keyboardType: type,
        decoration: InputDecoration(
          counterStyle: const TextStyle(height: double.minPositive,),
          counterText: "",
          hintText: label,
          helperStyle:  Theme.of(context).textTheme.bodySmall ,
         // labelText: label,
         // labelStyle: Theme.of(context).textTheme.bodySmall ,
          border: border ??  const OutlineInputBorder(),
          prefixIcon: Icon(
            prefixIcon,
            color: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple2,
          ),
          //suffixIcon: suffixIcon

        ),
      ),
    );
  }
}
