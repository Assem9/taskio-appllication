import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_helper/business_logic/app_cubit/app_states.dart';
import 'package:task_helper/business_logic/task_cubit/task_cubit.dart';
import 'package:task_helper/constants/my_colors.dart';
import 'package:task_helper/constants/strings.dart';
import 'package:task_helper/presentation/widgets/appbar.dart';
import 'package:task_helper/presentation/widgets/avatars_list_widget.dart';
import 'package:task_helper/presentation/widgets/default_button.dart';
import 'package:task_helper/presentation/widgets/textfield.dart';
import '../../business_logic/app_cubit/app_cubit.dart';
import '../../business_logic/task_cubit/task_states.dart';
import '../widgets/avatar.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<TaskCubit,TaskStates>(
        listener: (context, state){
          if(state is AccountUpdated){
            showToast(message: 'Your Account updated successfully');
          }
          if(state is AccountTasksLoaded){
            showToast(message: 'Done ');
          }
        },
        builder: (context, state){
          return BlocBuilder<AppCubit,AppStates>(
            builder: (context, state){
              return Center(
                  child: Stack(
                    children: [
                      buildAddNewAccountWidget(context),
                      buildMainAccountWidget(context),
                    ],
                  )
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMainAccountWidget(context){
    return AnimatedPositioned(
      duration: const  Duration(milliseconds: 400),
      left: AppCubit.get(context).accountMainWidgetPosition,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Choose Account: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 10,),
                buildPickFromAccountsWidget(context),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                UserAvatar(avatarUrl: TaskCubit.get(context).account!.avatar),
                const SizedBox(width: 25,),
                Text(
                  'Name: ${TaskCubit.get(context).account!.name} ',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                //const SizedBox(width: 25,),
                // UserAvatar(avatarUrl: AppCubit.get(context).account!.avatar),
              ],
            ),
            const SizedBox(height: 15,),
            DefaultTextField(
              controller: nameController,
              label: 'Want To Change It ?',
              type: TextInputType.text,
              prefixIcon: Icons.drive_file_rename_outline,
              maxLength: 10,
              border: const UnderlineInputBorder(),
            ),
            const SizedBox(height: 15,),
            Text(
              'Change your Avatar? ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15,),
            const AvatarsListView(),
            const SizedBox(height: 25,),
            DefaultButton(
                color: AppCubit.get(context).isDark ? null : MyColors.purple2,
                title: 'Submit Changes',
                onTap: ()=> TaskCubit.get(context).updateAccount(name: nameController.text,)
            ),
            Center(
              child: TextButton(
                  onPressed: ()=>AppCubit.get(context).accountAnimate(
                      firstPos: - MediaQuery.of(context).size.width,
                      secPos: 0
                  ),
                  child: Text(
                    'Want to add Another Account?',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.underline,),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPickFromAccountsWidget(context){
    return DropdownButton(
      dropdownColor: AppCubit.get(context).isDark? MyColors.darkColor : MyColors.white2,
        value: TaskCubit.get(context).account,
        items: TaskCubit.get(context).userAccounts.map((selectedChoice){
          return DropdownMenuItem(
              value: selectedChoice,
              child: Text( selectedChoice.name,style: Theme.of(context).textTheme.titleSmall,)
          );
        }).toList(),
        //onTap: ()=>TaskCubit.get(context).changeCurrentAccount(chosen: selectedAcc! ),
        onChanged: (selectedAcc){
          TaskCubit.get(context).changeCurrentAccount(chosen: selectedAcc! );
        }
    );
  }

  Widget buildAddNewAccountWidget(context){
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      right: AppCubit.get(context).addAccountWidgetPosition, //- MediaQuery.of(context).size.width ,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width ,
        //height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Adding New Account ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DefaultButton(
                      color: AppCubit.get(context).isDark? null : MyColors.purple2,
                      title: 'Back',
                      onTap: ()=> AppCubit.get(context).accountInitialAnimate(
                          firstPos: 0,
                          secPos: - MediaQuery.of(context).size.width
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            DefaultTextField(
              controller: nameController,
              label: 'Write Account Name',
              type: TextInputType.text,
              prefixIcon: Icons.drive_file_rename_outline,
              maxLength: 10,
              border: const UnderlineInputBorder(),
            ),
            const SizedBox(height: 15,),
            Text(
              'Pick your Avatar? ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15,),
            const AvatarsListView(),
            const SizedBox(height: 25,),
            TaskCubit.get(context).dataLoading
                ? const Center(child: CircularProgressIndicator(),)
                :
            DefaultButton(
                color: AppCubit.get(context).isDark? null : MyColors.purple2,
                title: 'SUBMIT',
                onTap: (){
                  if(nameController.text.isNotEmpty){
                    TaskCubit.get(context).createUserAccount(name: nameController.text);
                  }else{
                    showToast(message: 'Please Complete Your Data');
                  }
                }
            ),
          ],
        ),
      ),
    );
  }

}
