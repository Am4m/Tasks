import 'package:flutter/material.dart';
import 'package:task_manager/task/task_vault.dart';
import 'package:task_manager/widget/task_card.dart';
import 'package:task_manager/widget/task_form.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    var list = TaskVault.list;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateForm(context),
        tooltip: "Add task vault",
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: list,
          builder: (context, child) {
            var vaults = list.vaults;
            return ListView.builder(
              itemCount: vaults.length,
              itemBuilder: (context, index) {
                var vault = vaults[index];
                return Container(
                  margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: TaskCard(vault: vault),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

_showCreateForm(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return TaskForm(
          title: "Create new task",
          onSubmit: (name, desc) {
            var newVault = TaskVault(name, desc);
            TaskVault.list.addVault(newVault);
          },
        );
      },
    ),
  );
}
