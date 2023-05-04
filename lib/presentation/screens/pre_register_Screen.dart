import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/business_logic/app_cubit/app_states.dart';
import 'package:task_helper/constants/strings.dart';
import 'package:task_helper/presentation/widgets/app_logo_widget.dart';
import 'package:task_helper/presentation/widgets/default_button.dart';
import 'package:task_helper/presentation/widgets/textfield.dart';

import '../../business_logic/task_cubit/task_cubit.dart';
import '../../business_logic/task_cubit/task_states.dart';
import '../../constants/my_colors.dart';

class PreRegisterScreen extends StatelessWidget {
  PreRegisterScreen({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = TaskCubit.get(context).nameController ;
    return Scaffold(
      body: BlocConsumer<TaskCubit,TaskStates>(
        listener: (context, state){
          if(state is AccountTasksLoaded){
            Navigator.pushNamed(context, home);
          }
        },
        builder: (context, state){
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: ()=> AppCubit.get(context).changeTheme(null),
                    icon: Icon(
                      Icons.dark_mode,
                      size: 40,
                      color: AppCubit.get(context).isDark ? MyColors.mainWhite : MyColors.black,
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppLogoWidget(radius: 50),
                          const SizedBox(height: 20,),
                          Text(
                            'Welcome to :     ',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: AppCubit.get(context).isDark ? MyColors.lightColor : MyColors.purple4),
                          ),
                          Text(
                            'TASKEU',
                            style: Theme.of(context).textTheme.displaySmall!.copyWith( fontSize: 40),
                          ),
                          const SizedBox(height: 15,),
                          TaskCubit.get(context).dataLoading
                              ? const Center(child: CircularProgressIndicator(),)
                              : buildAccountDataForm(context)

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }

  Widget buildAccountDataForm(context){
    return Column(
      children: [
        Text(
          'Click GO And let\'s start adding tasks now !',
          style: Theme.of(context).textTheme.bodyMedium ,
        ),
        const SizedBox(height: 15,),
        DefaultTextField(
          controller: nameController,
          label: 'Write Your name',
          type: TextInputType.text,
          prefixIcon: Icons.person,
          maxLength: 10,
          border: const UnderlineInputBorder(), //InputBorder.none,
        ),
        Text(
          'Pick Your Avatar',
          style: Theme.of(context).textTheme.bodyLarge ,
        ),
        const SizedBox(height: 16,),
        buildAvatarsList(context),
        const SizedBox(height: 16,),
        DefaultButton(
          color: AppCubit.get(context).isDark? null : MyColors.purple3,
            title: 'GO',
            onTap: (){
              if(nameController.text.isNotEmpty){
                TaskCubit.get(context).createUserAccount(name: nameController.text);
              }else{
                showToast(message: 'Please Write Your name');
              }
            }
        ),
      ],
    );
  }

  Widget buildAvatarsList(context){
    return SizedBox(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio:1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index)=> InkWell(
          onTap: ()=>TaskCubit.get(context).pickAvatar(
            url: TaskCubit.get(context).avatars[index], name: nameController.text,
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
      ),
    ) ;
  }
}
