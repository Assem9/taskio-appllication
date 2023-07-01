import 'package:hive/hive.dart';
import 'package:task_helper/models/task_type_enum.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task{
  @HiveField(0)
  late String id ;
  @HiveField(1)
  late String title ;
  @HiveField(2)
  String? description ;
  @HiveField(3)
  late bool done;
  @HiveField(4)
  late double progress ;
  @HiveField(5)
  late List<String> notes ;
  @HiveField(6)
  late DateTime startDate ;
  @HiveField(7)
  late DateTime deadLine  ;
  @HiveField(8)
  late int color ;
  @HiveField(9)
  List<Map<String, String> > links ;
  @HiveField(10)
  late TaskType type ;
  @HiveField(11)
  late bool archived ;
  // subTasks saved in new Box
  List<Task> subTasks = [] ;

  Task({
    required this.id,
    this.description,
    required this.title,
    required this.done,
    required this.progress,
    required this.notes,
    required this.startDate,
    required this.deadLine,
    required this.color ,
    required this.links ,
    required this.type ,
    required this.archived ,
  });

}

