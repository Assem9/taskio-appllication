import 'package:flutter/material.dart';
import '../../constants/my_colors.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.color ,
    this.textStyle,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width ;
  final double? height ;
  final String title ;
  final Function onTap ;
  final Color? color;
  final TextStyle? textStyle ;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: height?? 40,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
        //  maximumSize: MaterialStateProperty.all<Size>(Size.fromWidth(200)),
         // fixedSize:MaterialStateProperty.all<Size>(Size.fromWidth(width?? 200),),
          backgroundColor: MaterialStateProperty.all<Color>(color?? MyColors.lightColor),
        ),
        onPressed: (){onTap();},
        child: Text(
          title,
          style: textStyle?? Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
