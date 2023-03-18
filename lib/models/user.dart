import 'package:hive/hive.dart';
import 'package:task_helper/models/task.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class Account{
  @HiveField(0)
  late String iD ;
  @HiveField(1)
  late String name ;
  @HiveField(2)
  late String avatar ;
  List<Task> plans = []; // task that has small tasks in it;
  List<Task> tasks = []; //
  List<Task> archive = []; // single task
  Account({
    required this.iD,
    required this.name,
    required this.avatar
  });



}