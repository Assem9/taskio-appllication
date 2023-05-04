import 'package:flutter/material.dart';
import '../../constants/my_colors.dart';

/*
shaderCallback: (Rect bounds) {
          return  const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                MyColors.white2,
               // MyColors.purple1,
                //MyColors.purple2 ,
                MyColors.lightColor,
              ]
          ).createShader(bounds);
        },
 */

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key, required this.radius}) : super(key: key);
  final double radius ;
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: MyColors.black,
      shadowColor: MyColors.purple3,
      elevation: 10,
      shape: BoxShape.circle,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.white2,
                MyColors.white3,
              ]
          ).createShader(bounds);
        },
        child: 
          Container(
            height:radius ,
            width: radius,
            decoration: const BoxDecoration(
                color: MyColors.black,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/images/logo_mark.JPG',),
                  fit: BoxFit.contain
              )
            ),
          )
        /*CircleAvatar(
            radius: radius , // MediaQuery.of(context).size.height/8,
            backgroundImage: const AssetImage('assets/images/logo_mark.JPG',)
        ),*/
      ),
    );
  }
}
