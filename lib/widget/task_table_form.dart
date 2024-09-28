import 'package:flutter/material.dart';
import 'package:task_manager/task/task.dart';

class TaskTableForm extends StatefulWidget {
  final void Function(Task) onSave;

  const TaskTableForm({super.key, required this.onSave});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskTableForm> {
  final TextEditingController _titleController = TextEditingController();
  Status _selectedStatus = Status.todo;
  Priority _selectedPriority = Priority.low;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final String title = _titleController.text;
    final Status status = _selectedStatus;
    final Priority priority = _selectedPriority;

    if (title.isNotEmpty) {
      final Task newTask = Task(
        title,
        priority,
        status,
      );
      widget.onSave(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            DropdownButtonFormField<Status>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: Status.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.text),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.text),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPriority = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
