import 'package:flutter/material.dart';
import 'package:todo_app/ui/widgets/main_screen/main_screen_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Tasks',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MainScreenWidget(),
    );
  }
}