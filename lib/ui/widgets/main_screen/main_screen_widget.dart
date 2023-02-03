import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/ui/widgets/main_screen/main_screen_widget_model.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/widgets/main_screen/main_screen_widget_task_model.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MainScreenWidgetModel();
    late String groupName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (context) => MainScreenWidgetModel(),
        child: const MainScreenWidgetBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Add new group',
                style: GoogleFonts.inter(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: .2,
                    color: const Color.fromRGBO(65, 63, 63, 1)
                ),
              ),
              content: TextField(
                autofocus: true,
                onChanged: (String value) {
                  groupName = value;
                },
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      model.addGroup(groupName);
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK')
                )
              ],
            );
          }
          );
        },
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}


class MainScreenWidgetBody extends StatelessWidget {
  const MainScreenWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      child: ListView.builder(
          itemCount: context.watch<MainScreenWidgetModel>().groups.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MainScreenGroupWidget(index: index);
          }
      ),
    );
  }
}

class MainScreenGroupWidget extends StatelessWidget {
  const MainScreenGroupWidget({Key? key, required this.index}) : super(key: key);
  final int index;


  @override
  Widget build(BuildContext context) {
    int groupKey = context.read<MainScreenWidgetModel>().indexToKey(index);
    final _model = context.read<MainScreenWidgetModel>();
    return Column(
      children: [
        Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) => _model.deleteGroup(index),
            child: Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _model.onGroupTap(index),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder,
                        color: Color.fromRGBO(65, 63, 63, 0.4),
                        size: 24,
                      ),
                      const SizedBox(width: 8.7),
                      Text(
                          _model.groups[index].title,
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: .2,
                                  color: Color.fromRGBO(65, 63, 63, 1)
                              )
                          )
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                          child: Container(
                            height: 1,
                            color: const Color.fromRGBO(188, 188, 195, 0.44),
                          )
                      ),
                      const SizedBox(width: 13),
                      Icon(
                        _model.groups[index].isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: const Color.fromRGBO(65, 63, 63, 1),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
        ChangeNotifierProvider(
          create: (context) => MainScreenWidgetTaskModel(groupKey: groupKey),
          child: MainScreenTasksWidget(
              groupIsOpen: _model.groups[index].isOpen
          ),
        )
      ],
    );
  }
}

class MainScreenTasksWidget extends StatelessWidget {
  const MainScreenTasksWidget({
    Key? key,
    required this.groupIsOpen
  }) : super(key: key);
  final bool groupIsOpen;



  @override
  Widget build(BuildContext context) {

    if (groupIsOpen == false) {
      return const SizedBox(height: 10);
    } else {
      return Column(
        children: [
          const SizedBox(height: 10),
          ListView.builder(
              itemCount: context.watch<MainScreenWidgetTaskModel>().tasks.length,
              itemExtent: 42,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return MainScreenTaskBody(index: index);
              }
          ),
          const SizedBox(height: 10),
          const MainScreenWriteTask(),
          const SizedBox(height: 10)
        ],
      );
    }
  }
}

class MainScreenTaskBody extends StatelessWidget {
  const MainScreenTaskBody({Key? key, required this.index,}) : super(key: key);
  final int index;

  Widget taskIcon(bool isDone) {
    if (isDone == true) {
      return const Icon(
        Icons.check_box_rounded,
        size: 22,
        color: Color.fromRGBO(196, 196, 196, 1),
      );
    } else {
      return const Icon(
        Icons.check_box_outline_blank_rounded,
        size: 22,
        color: Color.fromRGBO(196, 196, 196, 1),
      );
    }
  }

  TextStyle taskTappedStyle(bool isDone) {
    if (isDone == true) {
      return const TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 15,
        decoration: TextDecoration.lineThrough,
        color: Color.fromRGBO(181, 181, 186, 1),
      );
    } else {
      return const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color.fromRGBO(65, 63, 63, 1)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _model = context.read<MainScreenWidgetTaskModel>();
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => _model.deleteTask(index),
        child: InkWell(
          onTap: () => _model.onTaskTap(index),
          child: Row(
            children: [
              taskIcon(_model.tasks[index].isDone),
              const SizedBox(width: 8.7),
              Text(
                _model.tasks[index].title,
                style: GoogleFonts.inter(
                    textStyle: taskTappedStyle(_model.tasks[index].isDone)
                ),
              )
            ],
          ),
        )
    );
  }
}

class MainScreenWriteTask extends StatelessWidget {
  const MainScreenWriteTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();
    return TextField(
      maxLines: 1,
      controller: _controller,
      onSubmitted: (value) {
        context.read<MainScreenWidgetTaskModel>().addTask(value);
        _controller.clear();
      },
      decoration: InputDecoration(
          icon: const Icon(
            Icons.check_box_outline_blank_rounded,
            size: 22,
            color: Color.fromRGBO(226, 226, 226, 1),
          ),
          hintText: 'Write a task...',
          hintStyle: GoogleFonts.inter(
            textStyle: const TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color.fromRGBO(65, 63, 63, 0.6)
            ),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.only(left: -8.3),
          border: InputBorder.none,
          isCollapsed: true
      ),
    );
  }
}


