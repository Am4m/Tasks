import 'dart:core';
import 'package:flutter/material.dart';
import 'package:task_manager/task/task.dart';

class TaskVault with ChangeNotifier {
  static final list = _TaskList();

  bool _isPinned = false;
  final Set<Task> _tasks = {};
  final DateTime dateCreated = DateTime.now();
  String _name;
  String _description;

  TaskVault(this._name, this._description);

  Set<Task> get tasks => Set.unmodifiable(_tasks);
  String get name => _name;
  String get description => _description;
  bool get isPinned => _isPinned;

  set name(String name) {
    _name = name;
    list._notify();
  }

  set description(String description) {
    _description = description;
    list._notify();
  }

  void togglePinned() {
    _isPinned = !_isPinned;
    list._vaults.sort((a, b) {
      if (a.isPinned == b.isPinned) return 0;
      if (a.isPinned) return -1;
      return 1;
    });
    list._notify();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void addAllTask(Iterable<Task> tasks) {
    _tasks.addAll(tasks);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

class _TaskList with ChangeNotifier {
  final List<TaskVault> _vaults = [];

  List<TaskVault> get vaults => List.unmodifiable(_vaults);

  bool addVault(TaskVault vault) {
    if (vaults.any((element) => element.name == vault.name)) return false;
    _vaults.add(vault);
    notifyListeners();
    return true;
  }

  void removeVault(TaskVault vault) {
    _vaults.remove(vault);
    notifyListeners();
  }

  void _notify() {
    notifyListeners();
  }
}
