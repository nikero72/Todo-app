import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  Task({
    required this.title,
    required this.isDone
  });
}