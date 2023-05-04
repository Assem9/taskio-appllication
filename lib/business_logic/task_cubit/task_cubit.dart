import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task_helper/business_logic/cacheHelper.dart';
import 'package:task_helper/business_logic/task_cubit/task_states.dart';
import '../../constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../models/task.dart';
import '../../models/task_type_enum.dart';
import '../../models/user.dart';

class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(InitialState());
  static TaskCubit get(context) => BlocProvider.of(context);

  void cancelAnimation(){
    oneTaskWidth = 0 ;
    emit(AnimatingProgress());
  }

  double oneTaskWidth = 0 ;
  int nOfDoneTasks = 0 ;

  void setProgressWidthData({
    required Task plan,
    required double progressFullWidth
  }){
    nOfDoneTasks = 0 ;
    int nOfTasks = plan.subTasks.length ;
    for(Task sub in plan.subTasks){
      if(sub.done){
        nOfDoneTasks +=1 ;
      }
    }
    plan.progress = (nOfDoneTasks/nOfTasks)*100;
    debugPrint('${plan.progress}');
    oneTaskWidth = (progressFullWidth / nOfTasks)  ;//- (nOfDoneTasks * 0.2)
    emit(AnimatingProgress());
  }

  int setTaskWidgetColor(){
    var rand = Random();
    int index = rand.nextInt(MyColors.hiveColors.length);
    return MyColors.hiveColors[index] ;
  }

  List<String> avatars = ['avatar1.JPG','avatar2.JPG','avatar3.JPG','avatar4.JPG',];
  String avatar = 'avatar1.JPG';
  String nameController = '';
  void pickAvatar({required String url,required String? name}){
    avatar = url ;
    nameController = name! ;
    emit(AvatarPicked());
  }

  bool dataLoading = false ;
  Account? account ;
  //Acc-20230315210451
  void createUserAccount({required String name}) async{
    dataLoading = true ;
    emit(CreatingAccount());
    Account newAccount = Account(
        iD: generateUniqueId('Acc'),
        name: name,
        avatar: avatar
    );
    try{
      accountsBox.put(newAccount.iD, newAccount);
      debugPrint(newAccount.iD);
      allKeys ??= [];
      allKeys!.add(newAccount.iD);
      CacheHelper.saveList(key: 'allKeys', strings: allKeys!);
      CacheHelper.saveData(key: 'currentKey', value: newAccount.iD);
      currentAccKey = CacheHelper.getData(key: 'currentKey');
      emit(AccountCreated());
      getAccountData(newAccount.iD);
      getAllAccounts();
    }catch(e){
      debugPrint('creating acc error $e');
      emit(AccountCreatingError());
    }

  }

  void deleteAccount(accKey)async{
    try{
      await accountsBox.delete(accKey);
      allKeys!.remove(accKey);
      CacheHelper.saveList(key: 'allKeys', strings: allKeys!);
      emit(AccountDeleted());
    }catch(e){
      debugPrint('deleting acc $e');
    }

  }

  void updateAccount({
    required String name,
  }) async{
    bool avatarChanged = false;
    if(account!.avatar != avatar){
      avatarChanged = true;
    }
    Account updatedAccount = Account(
        iD: account!.iD,
        name: name.isEmpty? account!.name : name,
        avatar: avatarChanged?avatar : account!.avatar
    );
    try{
      await accountsBox.put(account!.iD, updatedAccount);
      debugPrint(account!.iD);
      emit(AccountUpdated());
      getAccountData(account!.iD);
    }catch(e){
      debugPrint('updating acc error $e');
      emit(AccountUpdatingError());
    }

  }

  late Box accountsBox;
  void openDataBase()async{
    try{
      accountsBox = await Hive.openBox(
          'accounts',
          path: directoryPath
      );
      if(currentAccKey != null){
        getAccountData(currentAccKey!); // ren4 => Acc-20230314083859 // f22 => Acc-20230314033110
        getAllAccounts();
      }

    }catch(e){
      debugPrint("opening Accounts error $e");
    }

  }


  List<Account> userAccounts = [];
  void getAllAccounts(){
    userAccounts = [];
    for(var key in allKeys!){
      Account loaded = accountsBox.get(key);
      userAccounts.add(loaded);
      debugPrint('${loaded.name + loaded.iD} ');
    }
  }

  void changeCurrentAccount({required Account chosen})async{
    // close all task boxes before you change account all it will access to the previous acc box not the new
    await tasksBox.close();
    await plansBox.close();
    getAccountData(chosen.iD);
    CacheHelper.saveData(key: 'currentKey', value: chosen.iD);
    emit(CurrentAccountChanged());
  }

  late Box tasksBox ;
  late Box plansBox ;
  void getAccountData(String accKey) async{
    try{
      account = await accountsBox.get(accKey);
      debugPrint(accKey);
      tasksBox = await Hive.openBox<Task>(
          'tasks',
          path:'$directoryPath/accounts/$accKey'
      );
      plansBox = await Hive.openBox<Task>(
          'plans',
          path:'$directoryPath/accounts/$accKey'
      );

      avatar = account!.avatar;
      emit(AccountDataLoaded());
      await Future.delayed(
          const Duration(milliseconds: 500),
              ()=> getAllTasks()
      );
    }catch(e){
      debugPrint('getAccount: $e');
    }

  }

  void fillArchive(List<Task> list){
    for(int i =0 ;i < list.length ;i++){
      if(list[i].archived){
        account!.archive.add(list[i]);
        list.remove(list[i]);
        i--;
      }
    }
  }

  void getAllTasks() async{
    account!.tasks = account!.plans = [];
    account!.tasks = tasksBox.values.toList() as List<Task> ;
    account!.plans = plansBox.values.toList() as List<Task> ;
    for(Task plan in  account!.plans){
      getPlanData(plan);
    }
    allItems = account!.tasks  + account!.plans;
    account!.archive = allItems.where((item) => item.archived).toList() ;
    updateHomeAllItems();
    dataLoading = false ;
    emit(AccountTasksLoaded());
    debugPrint(account!.plans.length.toString());
    debugPrint(account!.tasks.length.toString());
  }

  void updateHomeAllItems(){
    // plans + task without archived items
    allItems =
        account!.tasks.where((item) => !item.archived).toList() +
            account!.plans.where((item) => !item.archived).toList();
    sortAllItemsList();

  }

  List<Task> allItems = [] ;
  void sortAllItemsList(){
    // add more sorting types to user
    allItems.sort((a,b)=> a.startDate.compareTo(b.startDate));
    //allItems = List.from(allItems.reversed) ;
    emit(AllItemsListSorted());
  }

  late Task loadedPlan;
  void getPlanData(Task plan) async{
    subTasksBox = await Hive.openBox<Task>(
        'subTasks',
        path:'$directoryPath/AppDatabase/accounts/${account!.iD}/plans/${plan.id}'
    );
    plan.subTasks = subTasksBox.values.toList() as List<Task> ;
    loadedPlan = plan ;
    debugPrint(plan.subTasks.length.toString());
    emit(PlanSubTasksLoaded(plan));
   // Navigator.pushNamed(context, taskScreen,arguments: plan);
  }

  void addTask({
    required String title ,
    required String? description
  }) async{
    try{
      dataLoader = true ;
      emit(DataLoading());
      Task newTask = Task(
          id: generateUniqueId('task'),
          title: title,
          description: description,
          done: false,
          progress: 0,
          notes: [],
          startDate: startDate,
          deadLine: deadLine,
          color: setTaskWidgetColor(),
          links: [],
          type: TaskType.isTASK,
          archived: false
      );
      await tasksBox.put(newTask.id, newTask);
      account!.tasks.add(newTask);
      await Future.delayed(
          const Duration(milliseconds: 500),
              (){
                dataLoader = false ;
                emit(TaskAdded());
              }
      );
      //debugPrint('task added');
    }catch(e){
      debugPrint('error with adding task Box=> $e') ;
    }
  }


  void updateTaskData(Task updatedTask)async{
    try{
      await tasksBox.put(updatedTask.id, updatedTask);
      emit(TaskUpdated());
    }catch(e){
      emit(TaskUpdatingError());
      debugPrint('error with adding task Box=> $e') ;
    }
  }

  void updateTaskInDbByItsType(Task task){
    switch(task.type){
      case TaskType.isTASK:
        updateTaskData(task);
        break;
      case TaskType.isPLAN:
        updatePlan(plan: task);
        break;
      case TaskType.isSUBTASK:
        putSubTask(task);
        break;
    }
  }

  void archiveTask(Task archivedTask)async{
    try{
      archivedTask.archived = true ;
      updateTaskInDbByItsType(archivedTask);
      updateHomeAllItems();
      account!.archive.add(archivedTask);
      emit(TaskArchived(archivedTask.title));
    }catch(e){
      emit(TaskUpdatingError());
      debugPrint('error archiveTask=> $e') ;
    }
  }

  void completeTask(Task completedTask)async{
    try{
      completedTask.done = true ;
      updateTaskInDbByItsType(completedTask);
      emit(TaskIsDone(completedTask));
    }catch(e){
      emit(TaskUpdatingError());
      debugPrint('error completeTask=> $e') ;
    }
  }

  void deleteTask(Task chosenItem)async{
    try{
      switch(chosenItem.type){
        case TaskType.isTASK:
          await tasksBox.delete(chosenItem.id);
          account!.tasks.remove(chosenItem);
          break;
        case TaskType.isPLAN:
          await plansBox.delete(chosenItem.id);
          account!.plans.remove(chosenItem);
          break;
        case TaskType.isSUBTASK:
          await subTasksBox.delete(chosenItem.id);
          loadedPlan.subTasks.remove(chosenItem) ;
          break;
      }

      if(chosenItem.archived){
        account!.archive.remove(chosenItem);
      }
      emit(TaskDeleted(chosenItem.title));
    }catch(e){
      emit(TaskUpdatingError());
      debugPrint('error deleteTask=> $e') ;
    }
  }

  void addNewPlan({
    required String title ,
    required String? description
  })async{
    dataLoader = true ;
    emit(DataLoading());
    Task newPlan = Task(
        id: generateUniqueId('plan'),
        title: title,
        description: description,
        done: false,
        progress: 0,
        notes: [],
        startDate: startDate,
        deadLine: deadLine,
        color: setTaskWidgetColor(),
        links: [],
        type: TaskType.isPLAN,
        archived: false
    );
    try{
      await plansBox.put(newPlan.id, newPlan);
      account!.plans.add(newPlan);
      Hive.openBox<Task>(
          'subTasks',
          path:'$directoryPath/AppDatabase/accounts/${account!.iD}/plans/${newPlan.id}'
      ).then((value) async{
        subTasksBox = value ;
        for(Task sub in subTasksList){
          await subTasksBox.put(sub.id, sub);
        }
        subTasksList = [];
      });
      dataLoader = false ;
      await Future.delayed(
          const Duration(milliseconds: 500),
              ()=> emit(PlanAdded())
      );

      //debugPrint('Plan added');
    }catch(e){
      emit(PlanAddingError());
      debugPrint('error when adding Plan => $e');
    }
  }

  String generateUniqueId(String? text){
    return '${text??''}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now()) }';
  }

  late DateTime startDate ;
  late DateTime deadLine ;
  late Box subTasksBox ;
  List<Task> subTasksList = [];
  void addToSubTasksList({
    required String title ,
    required String ? description
  }) async{
    // add subTasks => 1- create new box named subTask 2- its path ends with plan.id
    Task subTask = Task(
        id: generateUniqueId('sub'),
        title: title,
        description: description,
        done: false,
        progress: 0,
        notes: [],
        startDate: startDate,
        deadLine: deadLine,
        color: setTaskWidgetColor(),
        links: [],
        type: TaskType.isSUBTASK,
        archived: false
    );
    subTasksList.add(subTask);
    emit(SubTaskAddedToList());

  }

  void updatePlan({required Task plan}) async{
    try{
      await plansBox.put(plan.id, plan);
      emit(PlanUpdated());
    }catch(e){
      debugPrint('updating plan error: $e') ;
      emit(PlanUpdatingError());
    }
  }

  bool dataLoader = false ;
  void addNewTaskToPlan({
    required String title ,
    required String ? description
  })async {
    //dataLoader = true ;
    emit(AddingSubTaskToDatabase());
    subTasksList = loadedPlan.subTasks;
    addToSubTasksList(title: title, description: description);
    //loadedPlan.subTasks = subTasksList ;
    // await subTasksBox.put(subTasksList.last.id, subTasksList.last);
    putSubTask(subTasksList.last);
    subTasksList = [];
    //dataLoader = false ;
    emit(SubTaskAddedToDatabase());
  }

  void putSubTask(Task sub)async{
    try{
      await subTasksBox.put(sub.id, sub);
    }catch(e){
      debugPrint('put subtask error $e');
    }

  }

  void addNewNote({
    required Task task,
    required String note
  }){
    task.notes.add(note);
    updateTaskInDbByItsType(task);
    emit(NewNoteAdded());
  }

  void deleteNote({
    required Task task,
    required String note
  }){
    task.notes.remove(note);
    updateTaskInDbByItsType(task);
    emit(NoteDeleted());
  }

  void addNewLink({
    required Task task,
    required Map<String,String> link
  }){
    task.links.add(link);
    updateTaskInDbByItsType(task);
    emit(NewLinkAdded());
  }
  void deleteLink({
    required Task task,
    required Map<String,String> link
  }){
    task.links.remove(link);
    updateTaskInDbByItsType(task);
    emit(NoteDeleted());
  }


}