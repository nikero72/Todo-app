import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/domain/data_provider/box_manager.dart';
import 'package:todo/domain/entity/group.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/ui/navigation/main_navigation.dart';

import '../tasks/tasks_widget.dart';


class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutesNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TasksWidgetConfiguration(
          group.key as int,
          group.name
      );
      Navigator.of(context).pushNamed(
          MainNavigationRoutesNames.tasks,
          arguments: configuration
      );
    }

  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final int groupKey = (await _box).keyAt(groupIndex);
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
      key: key,
      notifier: model,
      child: child);

  static GroupsWidgetModelProvider of(BuildContext context) {
    final GroupsWidgetModelProvider? result =
        context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
    assert(result != null, 'No GroupsWidgetModelProvider found in context');
    return result!;
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }
}
