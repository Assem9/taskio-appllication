import 'package:hive/hive.dart';
part 'task_type_enum.g.dart';

@HiveType(typeId: 2)
enum TaskType{
  @HiveField(0)
  isTASK,
  @HiveField(1)
  isPLAN,
  @HiveField(2)
  isSUBTASK,
}