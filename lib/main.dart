import 'package:flutter/material.dart';
import 'package:task_manager/task/task.dart';
import 'package:task_manager/task/task_vault.dart';
import 'package:task_manager/widget/task_list.dart';

void main() {
  var workout = TaskVault("workout", "My workout task");
  // workout.isPinned = true;
  workout.addAllTask({
    Task("Push up 50x", Priority.high, Status.todo),
    Task("Pull up 10x", Priority.medium, Status.todo),
    Task("Sit up 100x", Priority.low, Status.todo),
  });
  var consumption = TaskVault("consumption", "My consumption task");
  consumption.addAllTask({
    Task("Water", Priority.high, Status.done),
    Task("Rice", Priority.high, Status.inProgress),
    Task("Coffe", Priority.low, Status.done),
    Task("Meat", Priority.medium, Status.todo),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
    Task("Water", Priority.high, Status.done),
  });
  TaskVault.list.addVault(workout);
  TaskVault.list.addVault(consumption);
  runApp(const TaskManager());
}

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const TaskList(),
    );
  }
}
