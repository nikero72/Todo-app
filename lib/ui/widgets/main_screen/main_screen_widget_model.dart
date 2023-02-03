import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/entity/group.dart';

class MainScreenWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];
  Box<Group> groupBox = Hive.box('groupBox');
  ValueListenable<Object>? _listenableBox;

  List<Group> get groups => _groups.toList();

  MainScreenWidgetModel() {
    _setup();
  }

  int indexToKey(int groupIndex) {
    return groupBox.keyAt(groupIndex);
  }


  void addGroup(String groupName){
    Group group = Group(title: groupName, isOpen: false);
    groupBox.add(group);
    notifyListeners();
  }


  Future<void> deleteGroup(int index) async {
    var groupKey = groupBox.keyAt(index);
    await Hive.deleteBoxFromDisk('task_box_$groupKey');
    await groupBox.deleteAt(index);
    notifyListeners();
  }

  void onGroupTap(int index) {
    var _group = groupBox.getAt(index);
    _group?.isOpen = !_group.isOpen;
    groupBox.putAt(index, _group!);
    notifyListeners();
    print(groupBox.keyAt(index));
  }

  void _readGroupsFromHive() {
    _groups = groupBox.values.toList();
    notifyListeners();
  }

  void _setup() {
    _readGroupsFromHive();
    _listenableBox = groupBox.listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

}