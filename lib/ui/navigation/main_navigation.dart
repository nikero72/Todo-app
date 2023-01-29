import 'package:flutter/material.dart';

import '../widgets/group_form/group_form_widget.dart';
import '../widgets/groups/groups_widget.dart';
import '../widgets/task_form/task_form_widget.dart';
import '../widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRoutesNames {
  static const groups = '/';
  static const groupsForm = '/form';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRoutesNames.groups;
  final routes = {
    MainNavigationRoutesNames.groups: (context) => const GroupsWidget(),
    MainNavigationRoutesNames.groupsForm: (context) => const GroupFormWidget(),
    // MainNavigationRoutesNames.tasks: (context) => const TasksWidget(groupKey: ,),
    // MainNavigationRoutesNames.tasksForm: (context) => const TaskFormWidget(groupKey: ,),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    if (settings.name == MainNavigationRoutesNames.tasks) {
      final configuration = settings.arguments as TasksWidgetConfiguration;
      return MaterialPageRoute(
          builder: (context) => TasksWidget(configuration: configuration)
      );
    }
    if (settings.name == MainNavigationRoutesNames.tasksForm) {
      final groupKey = settings.arguments as int;
      return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupKey: groupKey)
      );
    }
    const widget = Text('Navigation error');
    return MaterialPageRoute(builder: (context) => widget);
  }
}
