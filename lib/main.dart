import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'domain/entity/group.dart';
import 'domain/entity/task.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TaskAdapter());
  }
  await Hive.openBox<Group>('groupBox');
  runApp(const MyApp());
}


