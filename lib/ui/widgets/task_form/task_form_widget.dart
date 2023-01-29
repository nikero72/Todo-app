import 'package:flutter/material.dart';
import 'package:todo/ui/widgets/task_form/task_from_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({
    Key? key,
    required this.groupKey
  }) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        model: _model,
        child: const _TextFormWidgetBody()
    );
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.watch(context)?.model;
    final actionButton = FloatingActionButton(
      onPressed: () => model?.saveTask(context),
      child: const Icon(Icons.done),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить новую задачу'),
      ),
      body: Center(
          child: Container(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _TasksTextWidget(),
            ),
          )
      ),
      floatingActionButton: model?.isValid == true ? actionButton : null,
    );
  }
}


class _TasksTextWidget extends StatelessWidget {
  const _TasksTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Задача'
      ),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
