import 'package:flutter/material.dart';
import 'package:task_helper/constants/my_colors.dart';


AppBar appBar(context) {
  return AppBar(
    title: Align(
        alignment:AlignmentDirectional.topEnd,
        child: Text(
          'TASKIO !',
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
        )
    ),
  );
}


