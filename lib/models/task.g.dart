// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      description: fields[2] as String?,
      title: fields[1] as String,
      done: fields[3] as bool,
      progress: fields[4] as double,
      notes: (fields[5] as List).cast<String>(),
      startDate: fields[6] as DateTime,
      deadLine: fields[7] as DateTime,
      color: fields[8] as int,
      links: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      type: fields[10] as TaskType,
      archived: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.done)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.deadLine)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.links)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.archived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
