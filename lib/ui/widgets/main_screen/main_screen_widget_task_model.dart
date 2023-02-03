import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/entity/task.dart';

class MainScreenWidgetTaskModel extends ChangeNotifier {
  int groupKey;
  var _tasks = <Task>[];
  late final Box<Task> _taskBox;
  ValueListenable<Object>? _listenableTaskBox;

  List<Task> get tasks => _tasks.toList();

  MainScreenWidgetTaskModel({
    required this.groupKey
}) {
    _taskSetUp(groupKey);
  }


  void addTask(String taskTitle){
    if (taskTitle.trim() != '') {
      Task task = Task(title: taskTitle, isDone: false);
      _taskBox.add(task);
      notifyListeners();
    }
  }

  void onTaskTap(int index) {
    var _task = _taskBox.getAt(index);
    _task?.isDone = !_task.isDone;
    _taskBox.putAt(index, _task!);
    notifyListeners();
  }

  void deleteTask(int index) {
    _taskBox.deleteAt(index);
    notifyListeners();
  }


  void _readTasksFromHive() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  Future<void> _taskSetUp(int groupKey) async {
    _taskBox = await Hive.openBox<Task>('task_box_$groupKey');
    _readTasksFromHive();
    _listenableTaskBox = _taskBox.listenable();
    _listenableTaskBox?.addListener(_readTasksFromHive);
  }
}